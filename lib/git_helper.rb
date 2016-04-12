module GitHelper
  def git_status
    `git status`.chomp
  end

  def git_dirty?
    git_status !~ /Your branch is up-to-date with 'origin\/master.*nothing to commit, working directory clean/
  end

  def git_out_of_sync?
    git_current_rev != git_origin_master_rev
  end

  def git_is_up_to_date_and_clean?
    git_origin_master_rev == git_current_rev && !git_dirty?
  end

  def git_current_branch
    `git rev-parse --abbrev-ref HEAD`.chomp
  end

  def git_current_rev
    `git rev-parse HEAD`.chomp
  end

  def git_origin_master_rev
    `git rev-parse origin/master`.chomp
  end


  def verify_git_status!
    if git_dirty? || git_out_of_sync?
      puts "\nWARNING! The current status of your repository is not in sync with the master branch in Github.\n\n"

      # Display git status if working tree is dirty
      if git_dirty?
        puts  "=========== CURRENT GIT STATUS ===========",
              git_status,
              "============= END GIT STATUS =============\n\n"
      end

      # Display branch/revision info if different from remote
      if git_out_of_sync?
        puts "Your branch and revision: #{git_current_branch}"
        puts "Your current revision: #{git_current_rev}"
        puts "\nGithub's branch: master"
        puts "Github's revision: #{git_origin_master_rev}\n"
      end
      
      # Abort the task unless the user explicitly types 'yes'
      ask(:response, 'You must type "yes" to proceed using your git repository in its current state')
      abort("Operation canceled by user\n\n") unless fetch(:response).downcase == 'yes'
    end
  end
end