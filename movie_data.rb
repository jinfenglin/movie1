class Tuple
	attr_accessor :first,:second
	def initialize(first,second)
		@first=first.to_i
		@second=second.to_i
	end
	def print_tuple
	puts first.to_s+":"+second.to_s
	end
end
#process the movie data as required 
class MovieData
	attr_accessor:database
	def initialize(path)
		@input=open(path)
		@database={}
	end
	
	def load_data
		@input.each do |line|
		#key is user id
			items=line.split("\t")
			info=[items[1],items[2],items[3]]
			if @database.has_key?(items[0])
				@database[items[0]].push(info)
			else
				@database[items[0]]=[]
			end
		end
		#print_database
	end
	
	def print_database
		@database.each do |key,info_list| 
			puts 'key:'+key
			info_list.each do |info|
				print info[0]+' '
				print info[1]+' '
				puts info[2]		
			end
		end
	end
	
	#sum the rating from user, the higher the better
	def popularity(movie_id)
		sum=0
		@database.each do |key,info_list|
			info_list.each do |info|
				if info[0].to_i==movie_id.to_i
					sum+=info[1].to_i
				end
			end
		end
		return sum
	end
	
	def popularity_list
		p_array=[]
		(1..1684).each do |n|
			puts n
			t=Tuple.new(n,popularity(n))
			p_array.push(t)
		end
		p_array.sort_by!{|x| -x.second}
		return p_array
	end
	
	def similarity(user1,user2)	
		u1_list=@database[user1.to_s]
		u2_list=@database[user2.to_s]
		score=0
		u1_list.each do |u1_info_list|
			u2_list.each do |u2_info_list|
				if u1_info_list[0]==u2_info_list[0]#watch same file
					score+=5-(u1_info_list[1].to_i-u2_info_list[1].to_i).abs
					break
				end
			end
		end
		return score
	end
	
	def most_similar(user)
		champion_id=0,champion_score=0
		(1..943).each do |other_id|
			 new_score=similarity(user,other_id)
			 if champion_score<=new_score && other_id != u
			 	champion_id=other_id
			 	champion_score=new_score
			 end
		end
		return champion_id
	end
end

moviedata=MovieData.new("./ml-100k/u.data")
moviedata.load_data
pop_list=moviedata.popularity_list
most_similar=moviedata.most_similar(1)
File.open('./result.txt','w') do |output|
	output.write( "10 most popular:")
	pop_list[1..10].each do |item|
		output.write(item.first)
		output.write(" ")
	end
	output.write("\n")
	output.write ("10 least popular:")
	pop_list[-10..-1].each do |item|
		output.write(item.first)
		output.write(" ")
	end
	output.write("\n")
	output.write("Most similarity user as user 1:")
	output.write(most_similar)
end