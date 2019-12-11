module Fastlane
  module Actions
    module SharedValues
      READ_PODSPEC_CUSTOM_VALUE = :READ_PODSPEC_CUSTOM_VALUE
    end

    class ReadPodspecAction < Action
      def self.run(params)
        require 'cocoapods-core'
        require 'cocoapods-core/specification/consumer'
        require 'cocoapods-core/platform'

        file_path = params[:file_path]
        platform  = params[:platform]
        platform ||= :ios

        Pod::Specification::Consumer.new(Pod::Specification.from_file(file_path), Pod::Platform.new(platform))
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
            key: :file_path,
            description: "/path/to/xx.podspec",
            verify_block: proc do |value|
              UI.user_error!("No file_path given") unless (value and not value.empty?)
              UI.user_error!("Couldn't find file at path '#{value}'") unless File.exist?(value)
            end
          ),
          FastlaneCore::ConfigItem.new(
            key: :platform,
            description: "CocoaPods supported platform。eg: iOS",
            optional: true
          )
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          ['READ_PODSPEC_CUSTOM_VALUE', 'A description of what this value contains']
        ]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ["Your GitHub/Twitter Name"]
      end

      def self.is_supported?(platform)
        # you can do things like
        #
        #  true
        #
        #  platform == :ios
        #
        #  [:ios, :mac].include?(platform)
        #

        platform == :ios
      end
    end
  end
end
