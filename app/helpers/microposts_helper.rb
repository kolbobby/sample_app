module MicropostsHelper
	def wrap(content)
		sanitize(raw(content.split.map{ |s| wrap_long_string(s) }.join(' ')))
	end

	def link_users(content)
		count = 0
		tildas = Array.new()
		spaces = Array.new()
		str = Array.new()
		name = Array.new()

		locate_i(content, tildas, spaces)
		(tildas.length).times do |t|
			(spaces.length).times do |s|
				if spaces[s] > tildas[t]
					str[count] = content[tildas[t] + 1..spaces[s] - 1]
					user = User.find(:first, :conditions => { :username => str[count] })
					content[tildas[t]..spaces[s]] = link_to("#{content[tildas[t]..spaces[s]]}", user)
					locate_i(content, tildas, spaces)
					count = count + 1
				end
			end
			count = 0
			name[t] = str[0]
		end

		wrap(content)
	end

	def locate_i(content, t, s)
		t_count = 0
		s_count = 0
		(content.length).times do |c|
			if content[c, 1] == '~'
				t[t_count] = c
				t_count = t_count + 1
			elsif content[c, 1] == ' '
				s[s_count] = c
				s_count = s_count + 1
			end
		end
	end

	private
		def wrap_long_string(text, max_width = 30)
			zero_width_space = "&#8203;"
			regex = /.{1,#{max_width}}/
			(text.length < max_width) ? text : text.scan(regex).join(zero_width_space)
		end
end