module GitHelper
  def git_status
    `git status`.chomp
  end

  def git_dirty?
    git_status !~ /Your branch is up-to-date with 'origin\/master.*nothing to commit, working directory clean'/
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
    if git_dirty? || git_out_of_sync
      puts <<-EOS

WARNING! The current status of your repository is not in sync with the master branch in Github.

=========== CURRENT GIT STATUS ===========
#{git_status}
============= END GIT STATUS =============

Your current branch: #{git_current_branch}
Your current revision: #{git_current_rev}

Github's current revision: #{git_origin_master_rev}

EOS
      
      ask(:response, 'You must type "yes" to proceed using your git repository in its current state')
      abort("Operation canceled by user\n\n") unless fetch(:response).downcase == 'yes'
    end
  end
end