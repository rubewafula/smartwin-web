<style >
.item {
    background: #613354;
    padding: 5px 10px;
    border-radius: 2px;
    margin-top: 2px;
    width: fit-content;
}

.item a{
    color:#ffffff;
}
.selected {
    background:#2c2457;
}
</style>


<table class="top--nav" width="100%">
    <tr>
        <td class="v-menu">
          <div class="item ">
            <a href="{{ url('virtuals/index') }}">Virtual Games</a>
        </div>
        </td>
        <td class="v-menu">
          <div class="item">
            <a href="{{ url('virtuals/casino') }}">Casino</a>
        </div>
        </td>

       <?php if ( strpos(strtolower($_SERVER['HTTP_HOST']),'test') !== false || preg_match('/127.0.0.1/', $_SERVER['HTTP_HOST']))  {  ?>
        <td class="v-menu">
          <div class="item selected">
            <a href="{{ url('virtuals/livecasino') }}">Live Casino</a>
          </div>
        </td>
        <?php } ?>
    </tr>
</table>
<table class="live-casino-games"> 
<tr><td class="live-casino" id="live-casino">

</td></tr>
</table>

    
<script>
        let tableKeys =[];
        let tableData = [];
        let dgaConnected;

    const initializeDGAEvents = async () => {
        window.dga.onWsError = (err) => {
         console.log("Error connecting DGA ws socket", err)
            
        }
        window.dga.onConnect = () => {
            dgaConnected = true;
             console.log("Successfully Connected DGA ws socket")
             getCasinoGames();
            
        }
        window.dga.onMessage = (data) => {
            console.log("Data On Message", data)
            //return false;
            let dataResult = []

            if (data.hasOwnProperty('tableKey')) {
                data?.tableKey?.forEach((key) => {
                    let result = {
                        id: key,
                        data: {}
                    }
                    dataResult.push(result)
                    if(!tableKeys.includes(key)) {
                        getGamesForTableKeys(key);
                    }
                })

                tableKeys = [...dataResult];
                console.log("Table result is ", tableKeys)
             
            } else {
                console.log("Table data is ", tableData)
                let localData = tableData
                console.log("Local Data is", localData);
                console.log("Found data is ", data)
                let index = tableData?.findIndex((item) => item.tableId === data?.tableId)
                console.log("Index found as ", index)
                if (index !== -1) {
                    localData[index] = data
                    console.log("Updated Local Data", localData)
                } else {
                    let length = localData.length
                    if (length === 0) {
                        localData[0] = data
                    } else {
                        localData[length] = data
                    }
                }
                tableData = [...localData];



                localStorage.setItem('tableData', JSON.stringify(tableData));

               

                if(tableKeys.length===tableData.length){
                    renderLiveCasinoGames()
                }

            }

            
        }
    }


    const initializeDGA = async () => {
        try {
            let url = "prelive-dga0.pragmaticplaylive.net/ws?key=testKey&stylename=lmntgmng_smartwin";
            window.dga.connect(url)
            console.log("Connected to DGA Web Socket on PP")
        } catch (e) {
            console.log("Error connecting to DGA Web Socket ", e)
        }
    }
    const getCasinoGames = () => {
        console.log("Getting Casino games")
        
            window.dga.available('ppcdk00000010157')
        
    }
    const getGamesForTableKeys = (key) => {
            window.dga.subscribe('ppcdk00000010157', key, 'Ksh')
    }

    const renderLiveCasinoGames =()=>{
        const data = JSON.parse(localStorage.getItem('tableData'));
        
            games = data.map((dataItem)=>
            (`<div class="cell" id="cell">

                    <div class="cell-header">
                        
                        <span>${dataItem?.tableName}</span>
                    </div>
                        <img 
                        src="${dataItem?.tableImage}"
                        alt=""
                        >

                <div class="casino-title">
                    <div class="casino-seats">
                        <span>
                        <svg
                        class="seats-icon" 
                        xmlns="http://www.w3.org/2000/svg"
                        viewBox="0 0 448 512">
                        <path d="M445.1 338.6l-14.77-32C425.1 295.3 413.7 288 401.2 288H46.76C34.28 288 22.94 295.3 17.7 306.6l-14.77 32c-4.563 9.906-3.766 21.47 2.109 30.66S21.09 384 31.1 384l.001 112c0 8.836 7.164 16 16 16h32c8.838 0 16-7.164 16-16V384h256v112c0 8.836 7.164 16 16 16h31.1c8.838 0 16-7.164 16-16L416 384c10.91 0 21.08-5.562 26.95-14.75S449.6 348.5 445.1 338.6zM111.1 128c0-29.48 16.2-54.1 40-68.87L151.1 256h48l.0092-208h48L247.1 256h48l.0093-196.9C319.8 73 335.1 98.52 335.1 128l-.0094 128h48.03l-.0123-128c0-70.69-57.31-128-128-128H191.1C121.3 0 63.98 57.31 63.98 128l.0158 128h47.97L111.1 128z"/></svg>
                        ${dataItem?.totalSeatedPlayers} Seats</span>
                    </div>

                    <button>
                        <a href="/virtuals/launch/${dataItem?.tableId}?live=1">
                            Play
                        </a>
                    </button>
                </div>

            </div>`));
            console.log(games)

            
    document.getElementById("live-casino").innerHTML = games.join('');
        

    }
    window.onload = (event) => {
        initializeDGA().then(() => {initializeDGAEvents()});
        
    };
    console.log("Connection state", dgaConnected)
    
  




</script>

