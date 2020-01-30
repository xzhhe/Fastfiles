module Fastlane
  module Actions
    module SharedValues
      WGET_CUSTOM_VALUE = :WGET_CUSTOM_VALUE
    end

    class WgetAction < Action
      def self.run(params)
        url    = params[:url]
        output = params[:output]
        tries  = params[:tries]
        quiet  = params[:quiet]

        tries ||= 0
        quiet ||= false

        cmds = ['wget']
        cmds << url
        cmds << "-O #{output}" if output
        cmds << "--tries=#{tries}" if tries.positive?
        cmds << '--quiet' if quiet
        Actions.sh(cmds.join(' '))
      end

      def self.description
        "A short description with <= 80 characters of what this action does"
      end

      def self.details
        "You can use this action to do cool things..."
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :url,
            description: "file download url",
            verify_block: proc do |value|
              UI.user_error!("No dsym filepath given") unless (value and not value.empty?)
            end
          ),
          FastlaneCore::ConfigItem.new(
            key: :output,
            description: "file download to disk file",
            optional: true
          ),
          FastlaneCore::ConfigItem.new(
            key: :tries,
            description: "retry 次数",
            is_string: false,
            type: Integer,
            optional: true
          ),
          FastlaneCore::ConfigItem.new(
            key: :quiet,
            description: "禁止输出",
            optional: true,
            default_value: false,
            is_string: false
          )
        ]
      end

      def self.output
        [
          ['WGET_CUSTOM_VALUE', 'A description of what this value contains']
        ]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.authors
        ["Your GitHub/Twitter Name"]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
