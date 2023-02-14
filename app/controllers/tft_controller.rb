class TftController < ApplicationController
    require 'google/apis/sheets_v4'

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

    #aggiunta della classifica aggiornata a google spreadsheet
    def addToSpreadsheet
        # Initialize the Google Sheets API client
        client = Signet::OAuth2::Client.new(access_token: current_user.token)
        service = Google::Apis::SheetsV4::SheetsService.new
        service.authorization = client

        # Create a new spreadsheet
        current_date = Time.now.strftime('%Y-%m-%d_%H-%M-%S')
        spreadsheet_name = "TFT-LEADERBOARD-#{current_date}"
        

        riot_key = Rails.application.credentials[:riot_key] 
        response = HTTP.get("https://euw1.api.riotgames.com/tft/league/v1/challenger", :params =>{:api_key => riot_key}).parse
        sorted_leaderboard = response["entries"].sort_by{ |obj| -obj["leaguePoints"] }.take(50)
        values = sorted_leaderboard.map { |obj| [obj["summonerName"], obj["leaguePoints"], obj["wins"], obj["losses"]] }
        range = "A1:D#{51}"
        header = [["Name", "Points", "Wins", "Losses"]]
        values = header+values

        spreadsheet = Google::Apis::SheetsV4::Spreadsheet.new(properties: { title: spreadsheet_name })
        spreadsheet = service.create_spreadsheet(spreadsheet)

        # Add the data to the spreadsheet
        result = service.update_spreadsheet_value(spreadsheet.spreadsheet_id, range, Google::Apis::SheetsV4::ValueRange.new(values: values), value_input_option: "USER_ENTERED")


        flash[:notice] = "<p>Your spreadsheet has been created. Check it out here:</p><a href='#{spreadsheet.spreadsheet_url}' target='_blank'>#{spreadsheet_name}</a>".html_safe
        redirect_to tft_leaderboard_path
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
