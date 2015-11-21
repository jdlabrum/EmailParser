class Regex  
	@domain

	def initialize(x)
		@domain = x
		@h = Hash.new {|h,k| h[k]=0}
		@a = Array.new
	end

	def parse_line(line)
		if @domain != ""
			if line =~ (/(.*)f=(\?q\?)?<([A-Za-z\d]+[-\w\.\*\_\&\/\+\=]*@([-A-Za-z\d\.\+\=\_]+\.[-\w]+))?>\:\st=(\?q\?)?<([A-Za-z\d]+[-\w\.\_\&\+\=]*@([-A-Za-z\d\.\+\=\_]+\.[-\w]+))?>(.*)(action=(\w+))\s/i)	
				@a<<$3<<$6
				if $10 == "discard"
					if $4 && ($4.downcase == @domain)
						if @h[$3.downcase]== 0
							@m = Hash.new
							@m["sent"]=0
							@m["received"]=0
							@m["discarded"]=0
							@m["seen"]=0
							@h[$3.downcase]=@m
						end
						@h[$3.downcase]["discarded"]+=1
						@h[$3.downcase]["seen"]+=1
					end
					if $7 && ($7.downcase == @domain)
						if @h[$6.downcase]== 0
							@m = Hash.new
							@m["sent"]=0
							@m["received"]=0
							@m["discarded"]=0
							@m["seen"]=0
							@h[$6.downcase]=@m
						end
						@h[$6.downcase]["discarded"]+=1
						@h[$6.downcase]["seen"]+=1
					end
				end
				if $10 != "discard"
					if $4 && ($4.downcase == @domain)
						if @h[$3.downcase]== 0
							@m = Hash.new
							@m["sent"]=0
							@m["received"]=0
							@m["discarded"]=0
							@m["seen"]=0
							@h[$3.downcase]=@m
						end
						@h[$3.downcase]["sent"]+=1
						@h[$3.downcase]["seen"]+=1
					end
					if $7 && ($7.downcase == @domain)
						if @h[$6.downcase] == 0
							@m = Hash.new
							@m["sent"]=0
							@m["received"]=0
							@m["discarded"]=0
							@m["seen"]=0
							@h[$6.downcase]=@m
						end
						@h[$6.downcase]["received"]+=1
						@h[$6.downcase]["seen"]+=1
					end
				end

				line = $8
				@discard = $10
				while line =~ (/t=(\?q\?)?<([A-Za-z\d]+[-\w\.\_\*\/\&\+\=]*@([-A-Za-z\d\.\+\=\_]+\.[-\w]+))?>(.*)/i) do
					if !@a.include?($2)
						if @discard == "discard"
							if $3 && ($3.downcase == @domain)
								if @h[$2.downcase]== 0
									@m = Hash.new
									@m["sent"]=0
									@m["received"]=0
									@m["discarded"]=0
									@m["seen"]=0
									@h[$2.downcase]=@m
								end
								@h[$2.downcase]["discarded"]+=1
								@h[$2.downcase]["seen"]+=1
							end
						end
						if @domain != "discard"
							if $3 && ($3.downcase == @domain)
								if @h[$2.downcase]== 0
									@m = Hash.new
									@m["sent"]=0
									@m["received"]=0
									@m["discarded"]=0
									@m["seen"]=0
									@h[$2.downcase]=@m
								end
								@h[$2.downcase]["received"]+=1
								@h[$2.downcase]["seen"]+=1
							end
						end
						@a<<$2
					end
					line = $4
				end
			end
			@a.clear
		end
	end

	def results
		return @h
	end
end