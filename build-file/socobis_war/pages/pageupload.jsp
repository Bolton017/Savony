<%@page import="bean.CGenUtil"%>
<%@page import="uploadbean.UploadPj"%>
<%
    try{
    String id = request.getParameter("id");
    if(request.getParameter("idDir")!=null && request.getParameter("idDir").compareTo("")!=0){
        id=request.getParameter("idDir");
    }
    String nomtable = request.getParameter("nomtable");
    UploadPj criteria = new UploadPj(nomtable);
    UploadPj[] listeUploaded = (UploadPj[]) CGenUtil.rechercher(criteria, null, null, " AND MERE = '" + id + "'");
    configuration.CynthiaConf.load();
    String cdn = configuration.CynthiaConf.properties.getProperty("cdnReadUri");
    String dossierTemp = request.getParameter("dossier");
    String dossier = dossierTemp 
        .replace("'","_")                
        .replace("-","_")
        .replace(":", "_")
        .replace("*", "_")
        .replace(" ", "_");
    int taille = 1;
%>
<div class="content-wrapper">
    <div class="row">
        <div class="col-md-12" style="padding: 1rem 4rem;">
            <div class="box-fiche">
                <div class="box" style="margin-bottom: 2rem">
                    <div class="box-title">
                        <h2 class="box-title" style="margin-left: 10px;">Les fichiers d&eacute;j&agrave; attach&eacute;s</h2>
                    </div>
                    <div class="box-body">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th style="background-color:#2c3d91; color: white">Libell&eacute;</th>
                                    <th style="background-color:#2c3d91; color: white">Fichier</th>
                                    <th style="background-color:#2c3d91; color: white">#</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%if (listeUploaded != null && listeUploaded.length > 0) {
                                        for (UploadPj element : listeUploaded) {%>
                                <tr>
                                    <td><%=utilitaire.Utilitaire.champNull(element.getLibelle())%></td>
                                    <td><%=element.getChemin()%></td>
                                    <td><a class="btn btn-danger" href="../DeletePj?but=<%=request.getParameter("but")%>&idpj=<%=element.getId()%>&id=<%=id%>&idDir=<%=id%>&nomtable=<%=request.getParameter("nomtable")%>&bute=<%=request.getParameter("bute")+"&idCommande="+request.getParameter("idCommande")+"&idDemandeCotation="+request.getParameter("idDemandeCotation")+"&idGroupeCommande="+request.getParameter("idGroupeCommande")%>&procedure=<%=request.getParameter("procedure")%>&enfant=<%=request.getParameter("enfant")%>">supprimer</a></td>
                                </tr>
                                <%}
                                } else {%>
                                <tr><td colspan="3" style="text-align: center;"><strong>Aucun fichier</strong></td></tr>
                                <%}%>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="box">
                    <div class="box-title">
                        <h4 class="box-title" style="margin-left: 10px">Uploader des fichiers pour l'identifiant : <%=id%></h4>
                        <h5 class="box-title" style="margin-left: 10px">Formats acc&eacute;pt&eacute;es : pdf, excel, jpg</h5>
                    </div>
                    <div class="box-body">                        
                        <form action="${pageContext.request.contextPath}/UploadDownloadFileServlet?dossier=<%=dossier%>" method="POST" enctype="multipart/form-data">
                            <div id="uploadapj">
                                <div class="form-group">
                                    <div class="col-xs-7" style="margin-right: -15px;">
                                        <input type="text" name="libelle<%=taille%>" placeholder="Titre" class="form-control" style="height: 30px;" multiple="true">
                                    </div>
                                    <div class="col-xs-5" style="margin-left: -15px;">
                                        <div class="input-group">
                                            <input type="file" name="fichiers<%=taille%>" class="form-control" style="height: 30px;" multiple="true">
                                            <div class="input-group-addon" onclick="removeLine(this)"><i class="fa fa-remove"></i></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <input type="hidden" name="classe" value="<%=request.getParameter("classe")%>">
                            <input type="hidden" name="nomtable" value="<%=request.getParameter("nomtable")%>">
                            <input type="hidden" name="procedure" value="<%=request.getParameter("procedure")%>">
                            <input type="hidden" name="bute" value="<%=request.getParameter("bute")%>">
                            <input type="hidden" name="id" value="<%=request.getParameter("id")%>">
                            <input type="hidden" name="idDir" value="<%=id%>">
                            <button type="button" class="btn btn-default pull-right" style="margin: 5px;" onclick="addLine()">Ajouter ligne(s)</button>
                            <button type="submit" class="btn btn-primary pull-right" style="margin: 5px;">Enregistrer</button>
                        </form>
                    </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
<script>
    function addLine() {
        <% taille++; %>
        var content = '<div class="form-group">'
                + '<div class="col-xs-7" style="margin-right: -15px;">'
                + '<input type="text" name="libelle<%=taille%>" class="form-control" multiple="true">'
                + '</div>'
                + '<div class="col-xs-5" style="margin-left: -15px;">'
                + '<div class="input-group">'
                + '<input type="file" name="fichiers<%=taille%>" class="form-control" multiple="true">'
                + '<div class="input-group-addon" onclick="removeLine(this)"><i class="fa fa-remove"></i></div>'
                + '</div>'
                + '</div>'
                + '</div>';
        $('#uploadapj').append(content);

    }
    function removeLine(obj) {
        $(obj).parent().parent().parent().remove();
    <% taille--;%>
    }
</script>
<%}catch(Exception ex){
        ex.printStackTrace();
        }%>