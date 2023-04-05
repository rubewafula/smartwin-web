<table >
    <tr>
        <td>
            {{ partial('partials/live-casino') }}
        </td>
    </tr>
</table>

<style>

.live-casino {
      box-sizing: border-box;
    display: flex;                       /* establish flex container */
    flex-wrap: wrap;                     /* enable flex items to wrap */
    justify-content:center;
    align-items: center;
    padding: 10px;
    column-gap: 10px;
    row-gap: 10px;
    margin: 0 auto;
  }
  .live-casino :first-child(){
    margin-left: 20px;
  }
  .casino-title button{

    width: 100%;
    padding: 5px 0;
    border: none;
    font-size:13px;
    text-transform: uppercase;
    text-decoration: none;
    border-radius: 3px;

  }
  .casino-title a{
    text-decoration: none ;

  }
  .cell {
    padding: 5px;
    height: auto;
    margin-bottom: 5px;
    background-color:#eaeaea;
    border-radius: 3px;
    box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2);
    transition: 0.3s;

  }
  .cell-header{
    font-size: 12px;
    color: #2c2457;
    text-align: center;
    font-weight:bold;
  }

  .cell img{
    margin-top: 5px;
    border-bottom-left-radius: 0;
    border-bottom-right-radius: 0;
    height: 80px;
    border-radius: 10px;
  }
  .cell button{
    margin-top: 5px;
    background: #902065;
    padding: 5px 0;
  }

  .cell button a, .cell button a:hover {
      color:#ffffff;
  }
  .casino-seats{
    text-align: center;
    color:#6383b4;
    font-size: 12px;
  }
  .seats-icon{
    width: 12px;
    fill: #ffc107;

  }



</style>
