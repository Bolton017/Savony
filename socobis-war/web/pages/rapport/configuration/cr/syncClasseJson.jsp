<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script>
    function synchroniser() {
        const exportZone = document.getElementById("exportZone");
        exportZone.innerHTML = "<h3>Exportation en cours...</h3><pre id='preZone'></pre>";

        fetch("rapport/configuration/cr/exportWorker.jsp")
            .then(response => response.text())
            .then(data => {
                document.getElementById('preZone').textContent = data;
            })
            .catch(err => {
                exportZone.innerHTML = "<span style='color:red;'>Erreur : " + err + "</span>";
            });
    }
</script>

<div class="content-wrapper">
    <h1>Synchronisation Classes/JSON</h1>
    <center><button onclick="synchroniser()" class="btn btn-success">Synchroniser</button></center>
    <div id="exportZone" style="max-height: 300px; overflow-y: auto; border: 1px solid #ccc; padding: 10px; margin: 20px; background: #f9f9f9; font-family: monospace; font-size: 12px;">
        <i>Appuyez sur Synchroniser pour commencer l'exportation.</i>
    </div>
</div>

<%
    try{
//        PdfGeneratorUtil.chartToImage();
//        PdfGeneratorUtil.base64();
    }catch (Exception e){

        e.printStackTrace();
    }
%>

