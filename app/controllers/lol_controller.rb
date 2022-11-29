class LolController < ApplicationController
    def review
    end

    def apicall
        #chiamata api summoner v4, serve per ottenere puuid e id utili per le chiamate successive
        riot_key = Rails.application.credentials[:riot_key]       
        response = HTTP.get("https://"+params[:region]+".api.riotgames.com/lol/summoner/v4/summoners/by-name/"+params[:summoner], :params =>{:api_key => riot_key})  
        summoner = response.parse

        #la chiamata all'api summoner v4 viene gestita dalla riot in questo modo:
        #1)se viene trovato un giocatore restituisce un json la cui prima entry è id, per quello controlliamo .include?"id"
        #2)altrimenti genera un codice di errore che gestiamo negli else
        if (JSON.generate(summoner).include?"id")
            #chiamata api league-v4, serve per ottenere le informazioni sul posizionamento in partite classificate del giocatore
            response = HTTP.get("https://"+params[:region]+".api.riotgames.com/lol/league/v4/entries/by-summoner/"+summoner['id'], :params =>{:api_key => riot_key})
            league = response.parse
            #controllare se la risposta di league-v4 restituisca [], in questo caso il giocatore non ha ancora giocato partite classificate questa stagione
           
            #chiamata api match-v5
            country = getCountry(params[:region])
            response = HTTP.get("https://"+country+".api.riotgames.com/lol/match/v5/matches/by-puuid/"+summoner['puuid'] + "/ids", :params =>{:count => 5, :api_key => riot_key})
            matchlist = response.parse
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
            matchData = Array.new(matchlist.count)
            for i in 0..matchlist.count-1
                response = HTTP.get("https://"+country+".api.riotgames.com/lol/match/v5/matches/"+matchlist[i], :params =>{:api_key => riot_key})
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
        response = HTTP.get("https://"+params[:region]+".api.riotgames.com/lol/league/v4/challengerleagues/by-queue/"+params[:queueType], :params =>{:api_key => riot_key}).parse
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
        content = Array.new(4)
        #dati relativi all'account
        sum = {'region' => region, 'name' => name, 'summonerLevel' => summoner['summonerLevel']}
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
        players = Array.new(10)
        k = 0
        for i in 0..matchcount-1
            for j in 0..9
                if  matchData[i]['info']['participants'][j]['summonerName'] == name
                    k = j
                    break
                end    
            end    

            match[i] = {'assists' => matchData[i]['info']['participants'][k]['assists'], 'deaths' => matchData[i]['info']['participants'][k]['deaths'], 
                'kills' => matchData[i]['info']['participants'][k]['kills'], 'championName' => matchData[i]['info']['participants'][k]['championName'], 
                'champLevel' => matchData[i]['info']['participants'][k]['champLevel'], 'goldEarned' => matchData[i]['info']['participants'][k]['goldEarned'],
                'lane' => matchData[i]['info']['participants'][k]['lane'], 'magicDamageDealt' => matchData[i]['info']['participants'][k]['magicDamageDealt'], 
                'physicalDamageDealt' => matchData[i]['info']['participants'][k]['physicalDamageDealt'], 'totalDamageDealt' => matchData[i]['info']['participants'][k]['totalDamageDealt'],
                'trueDamageDealt' => matchData[i]['info']['participants'][k]['trueDamageDealt'], 'turretKills' => matchData[i]['info']['participants'][k]['turretKills'],
                'visionScore' => matchData[i]['info']['participants'][k]['visionScore'], 'win' => matchData[i]['info']['participants'][k]['win'],
                'teamId' => matchData[i]['info']['participants'][k]['teamId'], 'date' => matchData[i]['info']['gameCreation'],
                'gameDuration' => matchData[i]['info']['gameDuration'], 'gameMode' => matchData[i]['info']['gameMode'], 'gameType' => matchData[i]['info']['gameType'],
                'gameVersion' => matchData[i]['info']['gameVersion'], 'mapId' => matchData[i]['info']['mapId'], 'gameType' => matchData[i]['info']['gameType']
            }
            players[i] = {'A_name_1' => matchData[i]['info']['participants'][0]['summonerName'], 'A_name_2' => matchData[i]['info']['participants'][1]['summonerName'],
                'A_name_3' => matchData[i]['info']['participants'][2]['summonerName'], 'A_name_4' => matchData[i]['info']['participants'][3]['summonerName'],
                'A_name_5' => matchData[i]['info']['participants'][4]['summonerName'], 'B_name_1' => matchData[i]['info']['participants'][5]['summonerName'],
                'B_name_2' => matchData[i]['info']['participants'][6]['summonerName'], 'B_name_3' => matchData[i]['info']['participants'][7]['summonerName'],
                'B_name_4' => matchData[i]['info']['participants'][8]['summonerName'], 'B_name_5' => matchData[i]['info']['participants'][9]['summonerName']
            }
        end
        content[2] = match
        content[3] = players    

        return content
    end    
    
end
