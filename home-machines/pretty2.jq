#
# jq -Rr 'include "pretty2"; pretty' some.js >some.js.pretty2
#
#   9 = \t
#  10 = \n
#  13 = \r
#  32 = (space)
#  34 = "
#  44 = ,
#  58 = :
#  91 = [
#  92 = \
#  93 = ]
# 123 = {
# 125 = }

def pretty:
  . as $input
  # | ( $input | .[0:80] | debug )
  | $input | explode | reduce .[] as $char (
    { out: [], indent: [], string: false, escape: false, prev: null, index: 0, recent: ""};
    if .string == true then
      .out += [$char]
      | if $char == 34 and .escape == false then .string = false else . end
      | if $char == 92 and .escape == false then .escape = true else .escape = false end
      | .prev = $char
    elif $char == 9 or $char == 10 or $char == 13 or $char == 32 then
      .
    else
      if $char == 93 then
        if .prev == 91 then .out += [91, 93]
        else .indent = .indent[2:] | .out += [10] + .indent + [93]
        end
      elif $char == 125 then
        if .prev == 123 then .out += [123, 125]
        else .indent = .indent[2:] | .out += [10] + .indent + [125]
        end
      else
        if .prev == 91 then .indent += [32, 32] | .out += [91, 10] + .indent
        elif .prev == 123 then .indent += [32, 32] | .out += [123, 10] + .indent
        else .
        end
        | if $char == 34 then .out += [$char] | .string = true
          elif $char == 58 then .out += [$char, 32]
          elif $char == 44 then .out += [$char, 10] + .indent
          elif $char == 91 or $char == 123 then .
          else .out += [$char]
          end
      end
      | .prev = $char
    end | .index += 1
  ) | .out | implode;
