# Repo Switcher
Migrate repositories between git service providers

# Why
Since Github is now offering [free private repositories for free](https://blog.github.com/2019-01-07-new-year-new-github/), I decided to migrate some of my private repositories from Gitlab and Bitbucket. This script helped not have to go through each repository and each of my machines to update their remote origins.

# Usage

```shell
$ git clone https://github.com/adhamu/repo-switcher.git
$ ./switch.sh -o [old service] -n [github|bitbucket|gitlab] -u [new service username]

$ cd ~/Projects
$ ~/path/to/repo-switcher/switch.sh -o gitlab -n github -u adhamu
```

**Note**: This script will look for repositories in whatever directory you are in so it can be run from any directory.

## Command Options
| Option | Description |
| -------| ------------|
| -o     | The old service you're moving your repository from. This can be a search term as it's passed to `grep` |
| -n     | The new service you're moving to. This currently can be set to *github*, *bitbucket* or *gitlab* |
| -u     | Your username for the new git service provider |
| -x     | Each "migration" will prompt you before it changes the remote origin. This "flag" skips all confirmation prompts. Use carefully |

# Assumptions
- You have already created the repository on the new service you're moving to (on the remote)
