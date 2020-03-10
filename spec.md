# Specifications for the Sinatra Assessment

Specs:
- [x] Use Sinatra to build the app - yes
- [x] Use ActiveRecord for storing information in a database - yes
- [x] Include more than one model class (e.g. User, Post, Category) -User, Workout and Goal
- [x] Include at least one has_many relationship on your User model (e.g. User has_many Posts) -User has many workouts and many goals 
- [x] Include at least one belongs_to relationship on another model (e.g. Post belongs_to User) -workouts belong to user and goals belong to user. workoutgoal belongs to workouts and goals
- [x] Include user accounts with unique login attribute (username or email) in user class 'validates_uniqueness_of :email' also have validations within the controllers so user cannot change URL to view other user's goals, workouts or account.
- [x] Ensure that the belongs_to resource has routes for Creating, Reading, Updating and Destroying -workout and goals can be created, read, updated and deleted.
- [x] Ensure that users can't modify content created by other users - Validations within the controllers so user cannot change URL to view other user's goals, workouts or account.
- [x] Include user input validations - Has 'required' where input is required, and HTML forms have "type" that must be the same as input type
- [x] BONUS - not required - Display validation failures to user with error message (example form URL e.g. /posts/new)
- [x] Your README.md includes a short description, install instructions, a contributors guide and a link to the license for your code

Confirm
- [x] You have a large number of small Git commits
- [x] Your commit messages are meaningful
- [x] You made the changes in a commit that relate to the commit message
- [x] You don't include changes in a commit that aren't related to the commit message
