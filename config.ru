require './config/environment'

use Rack::MethodOverride
use UserController
use WorkoutController
use GoalController
run ApplicationController