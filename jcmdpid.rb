#!/usr/bin/env ruby
require 'tmpdir'

# Explore a java pid
class JCmdPid

    def main
      parse_command_line
      execute
    end

    def parse_command_line
      @pid = ""
      ARGV.each do |arg|
        if ['/h', '/help', 'help'].include?(arg.downcase)
          help
          exit
        end
        @pid = arg
      end
    end

    def help
      puts green_message("JCmdPid v0.12 - Explore a java pid")
      puts
    end

    def execute
      output = `jcmd #{@pid}`
      if @pid.empty?
        puts "Select a valid pid from the list bellow:"
        puts output
        exit
      end

      output.each_line do |cmd|
        cmd = cmd.rstrip
        if cmd.start_with?(@pid) || cmd.start_with?("The follow") || cmd.start_with?("For more") || cmd == "help" || cmd.empty?
          next
        end
        extra = ''
        if cmd == "GC.heap_dump"
          extra = "#{Dir.tmpdir}/heapdump_pid_#{@pid}.hprof"
        end
        puts "Executando #{cmd}..."
        system("jcmd #{@pid} #{cmd} #{extra} > #{Dir.tmpdir}/jcmd_#{@pid}_#{cmd}.txt")
      end

    end

  end

  JCmdPid.new.main
