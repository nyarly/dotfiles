#!/bin/env ruby

require 'rubygems'
require 'time'
require 'thor'

module Ps
  class List
    include Enumerable

    def initialize
      @list = %x{ps --no-headers -elf}.each_line.map do |line|
        Entry.new(line)
      end
    end

    def ancestor_pids(pid)
      ancestors = [pid]
      until pid == 1
        pid = find{|ps| ps.pid == pid}.ppid
        ancestors << pid
      end
      return ancestors
    end

    def each
      @list.each do |it|
        yield it
      end
    end
  end

  class Entry
    attr_reader :state, :user, :pid, :ppid, :priority, :nice, :cmd
    def initialize(line)
      @f, @state, @user, @pid, @ppid, @c, @priority, @nice, @addr, @size, @wchan, @stime, @tty, @time, *@cmd = *line.split
      @f = @f.to_i
      @cmd = @cmd.join(" ")
      @pid = @pid.to_i
      @ppid = @ppid.to_i
      @priority = @priority.to_i
      @nice = @nice.to_i
      @size = @size.to_i
    end
  end
end

module Tmux
  def self.run(command)
    Commands.instance.run(command)
  end

  class Commands
    def initialize
      @exe = %x(which tmux).chomp
      @env = ENV["TMUX"]
    end

    def self.instance
      @instance ||= self.new
    end

    #def target_session

    def filter_commands(command)
      case command
      when "server-info", "info"
        true
      else
        false
      end
    end

    def run(command)
      cmd = "#@exe #{command}"
      raise "Not in a tmux" unless filter_commands(command) || @env
      %x(#{cmd})
    end
  end

  class CurrentPane
    attr_reader :session, :window, :pane
    def initialize
      @session, @window, @pane = Tmux.run("display -p '#S #I #P'").split(" ").map{|it| Integer(it) rescue it }
    end
  end

  class Info
    class InfoParser
      class Section
        def self.registry
          @registry ||= {}
        end

        def self.register(name)
          Section.registry[name] = self
        end

        def self.build(name, record)
          registry[name].new(record)
        end

        def initialize(record)
          @record = record
        end

        def first_line(line)
        end

        def parse_line(line)
        end
      end

      class Clients < Section
        register "Clients"
      end

      class Sessions < Section
        register "Sessions"

        def initialize(record)
          super
          @session = nil
        end

        def parse_line(line)
          case line
          when /([ \d]{2}): (\d+): (\d+) windows \(created ([^)]+)\) \[(\d+)x(\d+)\] \[flags=(\S+)\]/
            @session = Session.new
            @session.number = $~[1].to_i
            @session.window_count = $~[3].to_i
            @session.created = Time.parse($~[4])
            @session.width = $~[5].to_i
            @session.height = $~[6].to_i
            @session.flags = $~[7]
            @record.sessions << @session
          when /([ \d]{4}): (.*) \[(\d+)x(\d+)\] \[flags=(\S+), references=(\d+), .*\]/
            @window = Window.new
            @window.number = $~[1].to_i
            @window.title = $~[2]
            @window.width = $~[3].to_i
            @window.height = $~[4].to_i
            @window.flags = $~[5]
            @window.references = $~[6].to_i
            @window.session = @session
            @session.windows << @window
          when /([ \d]{6}): (\S+) (\d+) (-?\d+) (\d+)\/(\d+), (\d+) bytes; (\S+) (\d+)\/(\d+), (\d+) bytes/
            @pane = Pane.new
            @pane.number = $~[1].to_i
            @pane.ptty = $~[2]
            @pane.pid = $~[3].to_i
            @pane.fd = $~[4].to_i
            @pane.lines = $~[5].to_i
            @pane.hsize = $~[6].to_i
            @pane.window = @window
            @window.panes << @pane
          else
            raise "Can't parse #{line.inspect} as part of Sessions"
          end
        end
      end

      class Terminals < Section
        register "Terminals"
      end

      class Jobs < Section
        register "Jobs"
      end

      def initialize(string)
        @string = string
        @section = nil
      end
      attr_reader :record

      def build_record(version)
        case version
        when "7"
          InfoVersion7.new
        when "8"
          InfoVersion8.new
        else
          raise "Don't know tmux version #{version.inspect}"
        end
      end

      def go
        lines = @string.each_line
        lines = lines.drop_while{|line| /^protocol/ !~ line}
        version = (/^protocol version (?:is )?(\d*)/.match(lines.shift)[1])
        @record = build_record(version)

        @record.server_lines(lines)

        self
      end
    end

    class Session
      attr_accessor :number, :window_count, :created, :width, :height, :flags
      attr_reader :windows
      def initialize
        @windows = []
      end
    end

    class Window
      attr_accessor :number, :title, :width, :height, :flags, :references, :session
      attr_accessor :panes
      def initialize
        @panes = []
      end
    end

    class Pane
      attr_accessor :number, :ptty, :pid, :fd, :lines, :hsize, :window

      def inspect
        "Pane: #@number #@ptty #@pid"
      end
    end

    def self.build
      output = Tmux.run("server-info")
      parser = InfoParser.new(output).go
      parser.record
    end

    attr_accessor :protocol_version, :sessions
    def initialize
      @sessions = []
    end

    def locate_process(ancestors)
      sessions.each do |session|
        session.windows.each do |window|
          window.panes.each do |pane|
            return pane if ancestors.include?(pane.pid)
          end
        end
      end
      return nil
    end
  end

  class InfoVersion7 < Info
    def server_lines(lines)
      lines.each do |line|
        case line
        when /^([[:alpha:]]+):/
          @section = Section.build($1, @record)
          @section.first_line(line)
        when /^\s*$/
          @section = nil
        else
          @section.parse_line(line)
        end
      end
    end
  end

  class InfoVersion8 < Info
    def server_lines(lines)

    end

    def servers

    end

    def list_hashes(command, *fields)
      string = Tmux.run("#{command} -F '#{fields.map{|field| "\#{#{field}}"}.join(':')}'").encode("UTF-32", :invalid => :replace, :replace => '')
      string = string.encode("UTF-8", :invalid => :replace, :replace => '')
      string.each_line.map do |line|
        hash = Hash.new do |hash, key|
          raise "No #{key.inspect} in #{hash.inspect}"
        end

        fields.zip(line.split(":")).each do |field, value|
          hash[field] = value
        end

        hash
      end
    end

    def panes
      panes_hash.values
    end

    def sessions_hash
      @sessions_hash ||=
        begin
          Hash[list_hashes('list-sessions', :session_id, :session_name,
                           :session_windows, :session_created, :session_height, :session_width, :session_flags).map do |fields|
            session = Session.new
            session.number = Integer(fields[:session_name]) rescue fields[:session_name]
            session.window_count = fields[:session_windows].to_i
            session.created = Time.at(fields[:session_created].to_i)
            session.width = fields[:session_width].to_i
            session.height = fields[:session_height].to_i
            session.flags = fields[:session_flags]
            [fields[:session_id], session]
                           end]
        end
    end

    def windows_hash
      @windows_hash ||=
        begin
          Hash[list_hashes('list-windows -a', :session_id, :window_id,
                           :window_index, :window_name, :window_width, :window_height, :window_flags).map do |fields|
            window = Window.new
            window.number = fields[:window_index].to_i
            window.title = fields[:window_name]
            window.width = fields[:window_width].to_i
            window.height = fields[:window_height].to_i
            window.flags = fields[:window_flags]
            #window.references = fields[6].to_i
            window.session = sessions_hash[fields[:session_id]]
            [fields[:window_id], window]
          end]
        end
    end

    def panes_hash
      @panes_hash ||=
        begin
          Hash[list_hashes('list-panes -a', :session_id, :window_id, :pane_id,
                           :pane_index, :pane_tty, :pane_pid, :pane_height, :pane_width).map do |fields|
            pane = Pane.new
            pane.window = windows_hash[fields[:window_id]]
            pane.number = fields[:pane_index].to_i
            pane.ptty = fields[:pane_tty]
            pane.pid = fields[:pane_pid].to_i
            pane.lines = fields[:pane_height].to_i
            pane.hsize = fields[:pane_width].to_i
            [fields[:pane_id], pane]
          end]
        end
    end

    def locate_process(ancestors)
      panes.find do |pane|
        ancestors.include?(pane.pid)
      end
    end
  end
end

require 'timeout'
module Vim
  def self.command(cmd)
    Commands.instance.run(cmd)
  end

  class Commands
    def self.instance
      @instance ||= self.new
    end

    def initialize
      @exe = %x{which vim}.chomp
    end

    def run(command)
      command = "#@exe #{command}"
      Timeout::timeout(5) do
        %x{#{command}}
      end
    rescue Timeout::Error
      nil
    end
  end

  class Server
    def initialize(name)
      @name = name
    end
    attr_reader :name

    def expression(expr)
      server_command("--remote-expr '#{expr}'")
    end

    def send_keys(keys)
      server_command("--remote-send '#{keys}'")
    end

    def server_command(command)
      Vim.command("--servername #@name #{command}")
    end

    def pid
      @pid ||=
        begin
          get_pid = expression("getpid()") #sometimes long
          if get_pid.nil?
            nil
          else
            get_pid.to_i
          end
        end
    end

    def alive?
      !pid.nil?
    end
  end

  class ServerList
    include Enumerable

    attr_reader :servers

    def initialize(server_prefix)
      server_regexp = /^#{server_prefix||""}.*/i
      @servers = Vim.command("--serverlist").each_line.select do |server|
        server_regexp =~ server
      end.map do |server|
        Server.new(server.chomp)
      end.compact.find_all{|vim| vim.alive?}
    end

    def empty?
      @servers.empty?
    end

    def each
      @servers.each{|s| yield s }
    end
  end
end

class SessionVims
  include Enumerable

  attr_reader :session_vims

  def initialize(server_prefix)
    @server_prefix = server_prefix

    vims = Vim::ServerList.new(server_prefix)
    if vims.empty?
      vims = Vim::ServerList.new(nil)
    end
    tmux_info = Tmux::Info::build
    current_pane = Tmux::CurrentPane.new
    ps_list = Ps::List.new

    @session_vims = vims.find_all do |vim|
      ancestors = ps_list.ancestor_pids(vim.pid)
      pane = tmux_info.locate_process(ancestors)
      pane.window.session.number == current_pane.session
    end
  end

  def each
    @session_vims.each do |vim|
      yield vim
    end
  end
end

class YAMLCache
  def self.for(name, value, &block)
    new(name, value).get(&block)
  end

  def initialize(name, value)
    @name, @value = name, value
  end

  def all_cache
    @all_cache ||= load_cache
  end

  def cache
    all_cache.fetch('variables'){ @all_cache['variables'] = {}}
  end

  def load_cache
    require 'yaml'
    if File.file?(cache_path)
      YAML.load(File.read(cache_path))
    else
      {}
    end
  end

  def store_cache
    require 'yaml'
    File.write(cache_path, YAML.dump(all_cache))
  end

  def cache_path
    File.join(cache_dir, "cache.yaml")
  end

  def cache_dir
    File.expand_path('~/.config/tmux-engine')
  end

  def item_valid?(vim)
    return false unless vim.alive?

    ps_list.any? do |ps|
      ps.pid == vim.pid
    end
  rescue
    warn "Scrapping cached value because #$!"
    false
  end

  def ps_list
    @ps_list ||= Ps::List.new
  end

  def cache_key
    [@name, @value]
  end

  def raw_get
    cache.delete(cache_key)
    value = yield
    cache[cache_key] = value
    store_cache
    value
  end

  def get(&block)
    cached = cache[cache_key]
    unless cached.nil?
      valid = cached.find_all{|vim| item_valid? vim}
      if valid.empty?
        raw_get(&block)
      else
        if valid != cached
          cache[cache_key] = valid
          store_cache
        end
        valid
      end
    else
      raw_get(&block)
    end
  end

end

class CLI < Thor
  class_option :server_prefix

  desc "list-vims", "Quick listing of the Vims in the current TMUX"
  def list_vims
    SessionVims.new(options[:server_prefix]).each do |vim|
      p vim
    end
  end

  desc "normal-all KEYS", "Send keystrokes to all vim servers running in current session"
  def normal_all(keys)
    SessionVims.new(options[:server_prefix]).each do |vim|
      vim.send_keys("<Esc>:#{keys}<CR>")
    end
  end

  desc "find-variable NAME VALUE", "Find a session-local Vim server with a global variable set to a particular value"
  def find_variable(name, value)
    vims = YAMLCache.for(name, value) do
      SessionVims.new(options[:server_prefix]).find_all do |vim|
        vim.expression("exists(\"g:#{name}\") ? g:#{name} : \"MISSING\"").chomp == value
      end
    end
    vims = vims.map do |vim|
      vim.name
    end
    puts vims
  end

  desc "locate-vim SERVERNAME", "Return the session, window and pane for a vim server"
  method_options :pane  => :boolean
  def locate_vim(servername)
    vim = Vim::Server.new(servername)
    ancestors = Ps::List.new.ancestor_pids(vim.pid)
    pane = Tmux::Info.build.locate_process(ancestors)
    if options[:pane]
      puts "#{pane.window.session.number}:#{pane.window.number}.#{pane.number}"
    else
      puts "#{pane.window.session.number}:#{pane.window.number}"
    end
  end

  desc "locate-buffer FILENAME", "Return the server name for vims editing FILENAME"
  def locate_buffer(filename)
    vims = Vim::ServerList.new(options[:server_prefix]).find_all do |vim|
      vim.expression("bufexists(\"#{File::absolute_path(filename)}\")").chomp == "1"
    end.map do |vim|
      vim.name
    end
    puts vims
  end
end

CLI.start(ARGV)
