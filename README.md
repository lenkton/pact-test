# What is this

This is a solution to the problem described here: https://gist.github.com/wwwermishel/fd2c7973520c270c508720ba3a20e09c.

It features three endpoints at the moment:
1. GET /users
2. GET /users/:id
3. POST /users

# Skill vs Skil

In the problem there is a typo, that we need to fix.

It is asked to provide two solutions to this issue.

I see the following:

1. Just Ctrl+f and replace Skil with Skill throughout the entire project.
   * It should work just fine in the current example, but might be bothersome (and a little risky)
     in huge projects.
2. Move all the logic into a new Skill class, but leave the Skil class as an alias for Skill.
   * This way (mostly) all of the existing code shold work just fine with the Skil class name,
     which enables more graceful transition to Skill.

# Security concerns

## Authorization

There is no authorization/authentication mechanisms at all,
so it is too risky for running in a production environment.

## Index implementation

Also, in the `GET /users` I use `User.all` under the hood,
so it is risky to run against large numbers of users.
