   
module HTTPUtils
	require 'rest-client'

	def self.get(url, headers = {accept: "*/*"}, user = "", pass="")  # username and password go into headers as user: xxx and password: yyy
		
		
		begin
			request = RestClient::Request.new({
					method: :get,
					url: url.to_s,
					user: user,
					password: pass,
					headers: headers})
#$stderr.puts "GET request headers:", request.headers
response = request.execute()
			return response
		rescue RestClient::ExceptionWithResponse => e
			$stderr.puts e.response
			response = false
			return response  # now we are returning 'False', and we will check that with an \"if\" statement in our main code
		rescue RestClient::Exception => e
			$stderr.puts e.response
			response = false
			return response  # now we are returning 'False', and we will check that with an \"if\" statement in our main code
		rescue Exception => e
			$stderr.puts e
			response = false
			return response  # now we are returning 'False', and we will check that with an \"if\" statement in our main code
		end		  # you can capture the Exception and do something useful with it!\n",
	end


	def self.post(url, headers = {accept: "*/*"}, payload = "", user = "", pass="")  # username and password go into headers as user: xxx and password: yyy

		begin
			response = RestClient::Request.execute({
				method: :post,
				url: url.to_s,
				user: user,
				password: pass,
				payload: payload,
				headers: headers
			})
$stderr.puts "POST request headers:", response.request.headers
			return response
		rescue RestClient::ExceptionWithResponse => e
			$stderr.puts e.response
			response = false
			return response  # now we are returning 'False', and we will check that with an \"if\" statement in our main code
		rescue RestClient::Exception => e
			$stderr.puts e.response
			response = false
			return response  # now we are returning 'False', and we will check that with an \"if\" statement in our main code
		rescue Exception => e
			$stderr.puts e
			response = false
			return response  # now we are returning 'False', and we will check that with an \"if\" statement in our main code
		end		  # you can capture the Exception and do something useful with it!\n",
	end
	
	def self.put(url, headers = {accept: "*/*"}, payload = "", user = "", pass="")  # username and password go into headers as user: xxx and password: yyy

	  
		begin
			response = RestClient::Request.execute({
				method: :put,
				url: url.to_s,
				user: user,
				password: pass,
				payload: payload,
				headers: headers
			})
$stderr.puts "PUT request headers:", response.request.headers
			return response
		rescue RestClient::ExceptionWithResponse => e
			$stderr.puts e.response
			response = false
			return response  # now we are returning 'False', and we will check that with an \"if\" statement in our main code
		rescue RestClient::Exception => e
			$stderr.puts e.response
			response = false
			return response  # now we are returning 'False', and we will check that with an \"if\" statement in our main code
		rescue Exception => e
			$stderr.puts e
			response = false
			return response  # now we are returning 'False', and we will check that with an \"if\" statement in our main code
		end		  # you can capture the Exception and do something useful with it!\n",
	end



	def self.delete(url, headers = {accept: "*/*"}, user = "", pass="") 
	  
		begin
			response = RestClient::Request.execute({
				method: :delete,
				url: url.to_s,
				user: user,
				password: pass,
				headers: headers
			})
$stderr.puts "DELETE request headers:", response.request.headers
			return response
		rescue RestClient::ExceptionWithResponse => e
			$stderr.puts e.response
			response = false
			return response  # now we are returning 'False', and we will check that with an \"if\" statement in our main code
		rescue RestClient::Exception => e
			$stderr.puts e.response
			response = false
			return response  # now we are returning 'False', and we will check that with an \"if\" statement in our main code
		rescue Exception => e
			$stderr.puts e
			response = false
			return response  # now we are returning 'False', and we will check that with an \"if\" statement in our main code
		end		  # you can capture the Exception and do something useful with it!\n",
	end


	def self.patchttl(body)
		# this will reorder the turtle so that all prefix lines are at the top
		# this is NOT the right thing to do (since prefixes are allowed to be redefined)
		# however, the turtle parser pukes on out-of-order @prefix lines
		# so... given that almost nobody ever redefines a prefix, this solves most problems...
		prefixes = Array.new
		bodylines = Array.new
		body.split("\n").each {|l| prefixes.concat([l]) if l =~ /^\@prefix/i; bodylines.concat([l]) unless l =~ /^\@prefix/i}
		reintegrated = Array.new
		reintegrated.concat([prefixes, bodylines])
		fixedbody = reintegrated.join("\n")
		return fixedbody
	end
end

