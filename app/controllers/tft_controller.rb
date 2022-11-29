class TftController < ApplicationController
    def review
    end    

    def apicall
        riot_key = Rails.application.credentials[:riot_key]
        response = HTTP.get("https://"+params[:region]+".api.riotgames.com/tft/summoner/v1/summoners/by-name/"+params[:summoner], :params =>{:api_key => riot_key})  
        summoner = response.parse

        if (JSON.generate(summoner).include?"id")
            response = HTTP.get("https://"+params[:region]+".api.riotgames.com/tft/league/v1/entries/by-summoner/"+summoner['id'], :params =>{:api_key => riot_key})
            league = response.parse

            country = getCountry(params[:region])
            response = HTTP.get("https://"+country+".api.riotgames.com/tft/match/v1/matches/by-puuid/"+summoner['puuid'] + "/ids", :params =>{:count => 10, :api_key => riot_key})
            matchlist = response.parse
            if(matchlist == [])
                @@Send_NM = { "status"=> "NM" };
                respond_to do |format|
                    format.json {
                    render json: @@Send_NM
                    }
                end
            else    

            matchData = Array.new(matchlist.count)
            for i in 0..matchlist.count-1
                response = HTTP.get("https://"+country+".api.riotgames.com/tft/match/v1/matches/"+matchlist[i], :params =>{:api_key => riot_key})
                matchData[i] = response.parse
            end

            ret = formatJson(params[:region],params[:summoner], summoner, league, matchData, matchlist.count)
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
        response = HTTP.get("https://"+params[:region]+".api.riotgames.com/tft/league/v1/challenger", :params =>{:api_key => riot_key}).parse
        respond_to do |format|
            format.json {
              render json: response["entries"]
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

    def formatJson(region, name, summoner, league, matchData, matchcount)
        content = Array.new(3)
        #dati relativi all'account
        sum = {'region' => region, 'name' => name, 'summonerLevel' => summoner['summonerLevel'], 'count' => matchcount}
        sum.to_json
        content[0] = sum
        #dati relativi al posizionamento in classifica
        if league == []
            leag = {'tier' => 'unranked'}
        else    
        leag = {'queueType' => league[0]['queueType'], 'tier' => league[0]['tier'], 'rank' => league[0]['rank'], 
            'leaguePoints' =>  league[0]['leaguePoints'] , 'wins' =>  league[0]['wins'], 'losses' =>  league[0]['losses']}
        end    
        content[1] = leag
        #dati relativi ad ogni singola partita e tutti i nomi dei giocatori
        match = Array.new(matchcount)
        players = Array.new(8)
        for i in 0..matchcount-1
            k = 0
            for j in 0..7
                if  matchData[i]['metadata']['participants'][j] == summoner['puuid']
                    k = j
                    break
                end    
            end   
            matchData[i]['info']['participants'][k] 

            match[i] = {'gold_left' => matchData[i]['info']['participants'][k]['gold_left'], 'last_round' => matchData[i]['info']['participants'][k]['last_round'], 
                'level' => matchData[i]['info']['participants'][k]['level'], 'placement' => matchData[i]['info']['participants'][k]['placement'], 
                'players_eliminated' => matchData[i]['info']['participants'][k]['players_eliminated'], 'total_damage_to_players' => matchData[i]['info']['participants'][k]['total_damage_to_players'],
                'augments' => matchData[i]['info']['participants'][k]['augments'], 'traits' => matchData[i]['info']['participants'][k]['traits'],
                'units' => matchData[i]['info']['participants'][k]['units'], 'date' => matchData[i]['info']['game_datetime'], 'game_length' => matchData[i]['info']['game_length']          
            }
        end
        content[2] = match
   

        return content
    end
    
    
end
