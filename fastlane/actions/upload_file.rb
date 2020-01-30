module Fastlane
  module Actions
    class UploadFileAction < Action
      def self.run(params)
        # require 'rest-client'
        require 'pp'

        host     = params[:host]
        filepath = params[:filepath]

        UI.user_error!("❌ [upload_file] host not exist")

        # stage=beta
        # version=6.15.0 (iOS xcode project build)
        # build=3640 (jenkins job build id)
        stage   = params[:stage]
        version = params[:version]
        build   = params[:build]

        unless File.exist?(filepath)
          UI.error("❌ [upload_file] #{filepath} not exist")
          return nil
        end

        UI.important("❗[upload_file] host: #{host}")
        UI.important("❗[upload_file] filepath: #{filepath}")
        UI.important("❗[upload_file] stage: #{stage}")
        UI.important("❗[upload_file] version: #{version}")
        UI.important("❗[upload_file] build: #{build}")

        #
        # curl https://xxxx/upload \
        #   -F "file=@/path/to/file" \
        #   -F "stage=test" \
        #   -F "version=6.24.0" \
        #   -F "build=1695"
        #

        cmds = []
        cmds << "curl #{host}"
        cmds << "-F \"file=@#{filepath}\""
        cmds << "-F \"stage=#{stage}\"" if stage && !stage.empty?
        cmds << "-F \"version=#{version}\"" if version && !version.empty?
        cmds << "-F \"build=#{build}\"" if build && !build.empty?
        cmd = cmds.join(' ')
        UI.important("❗[upload_file] cmd: #{cmd}")
        system(cmd)

        # return file download url
        # ...
      end

      # def self.upload
      #   options = {
      #     'multipart' => true,
      #     'file' => File.open(filepath, 'rb'),
      #   }
      #   options['stage'] = stage if stage
      #   options['version'] = version if version
      #   options['build'] = build if build

      #   UI.important('⚠️  [upload_file] options:')
      #   pp options

      #   RestClient.post(
      #     host,
      #     # options
      #     {
      #       'multipart' => true,
      #       'file' => File.open(filepath, 'rb'),
      #       'stage' => 'beta',
      #       'version' => version,
      #       'build' => build
      #     }
      #   )
      # end

      def self.description
        "A short description with <= 80 characters of what this action does"
      end

      def self.details
        "You can use this action to do cool things..."
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :host,
            description: "host",
            optional: true
          ),
          FastlaneCore::ConfigItem.new(
            key: :filepath,
            description: "upload file path",
            verify_block: proc do |value|
              UI.user_error!("No filepath pass ") unless (value and not value.empty?)
            end
          ),
          FastlaneCore::ConfigItem.new(
            key: :stage,
            description: "stage",
            optional: true
          ),
          FastlaneCore::ConfigItem.new(
            key: :version,
            description: "version",
            optional: true
          ),
          FastlaneCore::ConfigItem.new(
            key: :build,
            description: "build",
            optional: true
          )
        ]
      end


      def self.authors
        ["xiongzenghui"]
      end

      def self.is_supported?(platform)
        platform == :ios
      end
    end
  end
end
