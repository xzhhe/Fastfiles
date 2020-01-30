all:
	bundle install
	NAME='xiongzenghui' bundle exec fastlane hello

rm_derived_data:
	bundle install
	bundle exec fastlane run rm_derived_data

rubygems:
	rm -rf ~/.bundle/config
	gem sources --add https://rubygems.org/ --remove https://gems.ruby-china.com/

rubychina:
	rm -rf ~/.bundle/config
	bundle config -- delete 'mirror.https://rubygems.org/'
	bundle config 'mirror.https://rubygems.org/' 'https://gems.ruby-china.com/'
