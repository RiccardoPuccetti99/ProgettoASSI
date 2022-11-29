class LorController < ApplicationController
    def review
    end
    
    def apicall
        riot_key = Rails.application.credentials[:riot_key]       
        response = HTTP.get("https://"+params[:region]+".api.riotgames.com/lol/summoner/v4/summoners/by-name/"+params[:summoner], :params =>{:api_key => riot_key})  
        summoner = response.parse
        puuid = summoner['puuid']

        if (JSON.generate(summoner).include?"id")
            country = getCountry(params[:region])
            response = HTTP.get("https://"+country+".api.riotgames.com/lor/match/v1/matches/by-puuid/"+summoner['puuid'] + "/ids", :params =>{:api_key => riot_key})
            matchlist = response.parse.reverse!

            #i match id in matchlist sono dal più recente al più vecchio
            if(matchlist == [])
                @@Send_NM = { "status"=> "NM" };
                respond_to do |format|
                    format.json {
                    render json: @@Send_NM
                    }
                end
            else

            #chiamata api matchdata
            enemy = Array.new(5)
            matchData = Array.new(5)
            for i in 0..4
                k = 0
                response = HTTP.get("https://"+country+".api.riotgames.com/lor/match/v1/matches/"+matchlist[i], :params =>{:api_key => riot_key})
                matchData[i] = response.parse
                if matchData[i]['info']['players'].count == 1
                    enemy[i] = 'AI'
                else    
                    if puuid == matchData[i]['metadata']['participants'][0] 
                        k = 1
                    end       
                    response = HTTP.get("https://"+params[:region]+".api.riotgames.com/lol/summoner/v4/summoners/by-puuid/"+matchData[i]['metadata']['participants'][k], :params =>{:api_key => riot_key})
                    enem = response.parse
                    if (JSON.generate(enem).include?"id")
                        enemy[i] = enem['name']
                    else
                        enemy[i] = "Cannot retrieve name"
                    end        
                end    
            end

            ret = formatJson(params[:region],params[:summoner],puuid, enemy , matchData, summoner['summonerLevel'])
            #invio dei dati in json
            respond_to do |format|
                format.json {
                  render json: ret
                }
            end
        end
         else
            @@Send_404 = { "status"=> "404" };
            respond_to do |format|
                format.json {
                  render json: @@Send_404
                }
            end 
        end 

    end


    def leaderboard     
    end

    def leaderboardAPI
        riot_key = Rails.application.credentials[:riot_key] 
        response = HTTP.get("https://"+params[:region]+".api.riotgames.com/lor/ranked/v1/leaderboards/", :params =>{:api_key => riot_key}).parse
        respond_to do |format|
            format.json {
              render json: response["players"]
            }
        end
    end 
    
    

    private

    def getCountry(region)
        case region
        when "euw1","eun1","tr1","ru"
            return "europe" 
        when "jp1","kr"
            return "asia"
        when "na1","br1","oc1","la1","la2"
            return "americas"
        else
            #default
            return "europe"                   
        end 
    end

    def formatJson(region, name,puuid, enemy, matchData, level)
        content = Array.new(3)
        #dati relativi all'account
        sum = {'region' => region, 'name' => name, 'summonerLevel' => level}
        sum.to_json
        content[0] = sum

        match = Array.new(5)
        matchEnemy = Array.new(5)   
        for i in 0..4
            if enemy[i] == 'AI'
                matchEnemy[i] = {'name' => 'AI' ,'deck_code' => 'AI_DECK', 'factions' => 'AI_FACTIONS'}
                k=0
            else
            k = 0
            x = 1
                if  matchData[i]['metadata']['participants'][0] == puuid
                else 
                    k=1
                    x=0
                end
                matchEnemy[i] = {'name' => enemy[i],'deck_code' => matchData[i]['info']['players'][x]['deck_code'], 'factions' => matchData[i]['info']['players'][x]['factions']
                }
            end            

            match[i] = {'game_mode' => matchData[i]['info']['game_mode'], 'game_type' => matchData[i]['info']['game_type'],
                'deck_code' => matchData[i]['info']['players'][k]['deck_code'], 'factions' => matchData[i]['info']['players'][k]['factions'],
                'game_outcome' => matchData[i]['info']['players'][k]['game_outcome'], 'order_of_play' => matchData[i]['info']['players'][k]['order_of_play'],
                'total_turn_count' => matchData[i]['info']['total_turn_count']
            }         
        end
        content[1] = match
        content[2] = matchEnemy   

        return content
    end 

end
