lane :deploy_ios_pod do |options|
  podspec = options[:podspec]
  branch  = options[:branch]
  version = options[:version]

  branch ||= 'master'

  UI.user_error!("❌ invalid podspec path: #{podspec} not exist") unless File.exist?(podspec)
  UI.user_error!("❌ invalid target version: #{version} empty") unless version
  UI.user_error!("❌ invalid target version: #{version} empty") if version.empty?

  podspec_dir  = File.dirname(podspec)
  podspec_name = read_podspec(file_path: podspec)
  UI.confirm("confirm push repo version is #{version}, pod is #{podspec_name}")

  ensure_git_status_clean_pwd(path: podspec_dir)
  # ensure_git_branch(branch: 'master')

  pod_lib_lint(
    verbose: true,
    allow_warnings: true,
    podspec: podspec,
    # sources: ["https://github.com/username/Specs", "https://github.com/CocoaPods/Specs"],
    use_bundle_exec: true,
    fail_fast: false
    # use_libraries: true
  )

  # scan(
  #   workspace: "Example/#{PODSPEC_NAME}.xcworkspace",
  #   scheme: "#{PODSPEC_NAME}Demo",
  #   devices: ["iPhone 6s", "iPhone 7"],
  #   output_directory: "~/Downloads"
  # )

  # increment_version_number(version_number: version) # xcodeproj
  version_bump_podspec(
    path: podspec,
    version_number: version
  )

  commit_message = "Bump version to #{version}"
  git_commit_push(
    repo: podspec_dir,
    commit_message: commit_message,
    branch: branch
  )

  if git_tag_exist(repo: podspec_dir, tag: version)
    UI.important("❗️发现 tag:#{version} 存在, 即将执行删除")
    git_delete_tag(
      repo: podspec_dir,
      tag: version,
      local: true,
      remote: true
    )
  end

  git_tag_add_push(
    repo: podspec_dir,
    tag: version,
    branch: branch,
    commit_message: commit_message
  )

  pod_push(
    path: podspec,
    # repo: The repo you want to push. Pushes to Trunk by default,
    # sources: The sources of repos you want the pod spec to lint with, separated by commas,
    allow_warnings: true,
    use_libraries: true
  )
end
