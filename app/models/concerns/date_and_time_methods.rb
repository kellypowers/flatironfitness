# # require 'sinatra/base'

# # module Sinatra
#     module DateAndTimeMethods


#         #puts date in format Month, DD, YYY
#         def date_printed(dates)
#             date = self.dates.to_s
#             item = Date.parse(date)
#             "#{Date::MONTHNAMES[item.month]} #{item.day}, #{item.year}"
#         end

#         #puts the date in format to be saved in the calendar when editing workout/goal
#         def date_format_for_form_value(date)
#             d = Date.parse(date.to_s)
#             d.strftime("%Y-%m-%d")
#         end

#         #converts all time units to minutes to calculate progress
#         def time_unit_minutes
#             time = nil
#             if self.time != 0
#                 if self.time_units == "minute(s)"
#                     time = self.time 
#                 else
#                     time = self.time * 60
#                 end
#             else
#                 time = self.time
#             end
#             time
#         end
#     end
  
# # end
