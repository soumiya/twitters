class Tweet  
include HTTParty
base_uri "search.twitter.com"
attr_accessor :from_user,:profile_image_url,:created_at,:message,:message_type

#Pulls tweets from search.twitter.com public api
  def self.search(options={})
       resultset={:result_type => 'mixed',:success => false}
       begin
          raise 'invalid query' if options[:q].blank?
          resultset.merge!(options)
          res=get("/search.json?",:query => resultset)
          if(res.code == 200)
           parsed_response=res.parsed_response
           resultset[:success] = true
           resultset[:tweets]=Array.new
           if parsed_response.key?('results')
             parsed_response['results'].each {|item|
               t=self.new
               t.from_user=item['from_user'] || 'unknown'
               t.profile_image_url=item['profile_image_url']
               t.created_at=item['created_at']
               t.message=item['text']
               t.message_type=item['metadata']['result_type']
               resultset[:tweets] << t
             }
           end
           resultset[:max_id]=parsed_response['max_id']
           resultset[:page]=parsed_response['page']
           resultset[:next_page]=true if parsed_response.key?('next_page')         
          end
       rescue => e
          Rails.logger.debug("Tweet search err  : #{e.message}")
       end
       resultset
   end


end
