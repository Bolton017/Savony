<%-- 
    Document   : escompte-modif
    Created on : 6 janv. 2023, 13:56:18
    Author     : ThinkPad
--%>
<%@page import="facture.tr.Escompte"%>
<%@ page import="user.*"%>
<%@ page import="bean.*"%>
<%@ page import="utilitaire.*"%>
<%@ page import="affichage.*"%>
<%
    String autreparsley = "data-parsley-range='[8, 40]' required";
    
    Escompte esc = new Escompte();
    esc.setNomTable("ESCOMPTE");
    PageUpdate pi = new PageUpdate(esc, request, (user.UserEJB) session.getValue("u"));

    pi.getFormu().getChamp("IDTRAITE").setLibelle("Traite");
    pi.getFormu().getChamp("IDTRAITE").setAutre("readonly");
    pi.getFormu().getChamp("ETAT").setAutre("readonly");
    
    pi.setLien((String) session.getValue("lien"));
    UserEJB u = (UserEJB) session.getAttribute("u");
    pi.preparerDataFormu();
%> 

<div class="content-wrapper">
    <div class="row">
        <div class="col-md-6 col-md-offset-3">
            <div class="">
                <div class="box">
                    <h1>Modification escompte</h1>
                    <form action="<%=(String) session.getValue("lien")%>?but=apresTarif.jsp" method="post" name="recettebordereau" id="recettebordereau">
                        <%
                            out.println(pi.getFormu().getHtmlInsert());
                        %>
                        <div class="row">
                            <div class="col-md-11">
                                <button class="btn btn-warning pull-right" name="Submit2" type="submit">Enregistrer les modifications</button>
                            </div>
                            <br><br> 
                        </div>
                        <input name="acte" type="hidden" id="acte" value="update">
                        <input name="bute" type="hidden" id="bute" value="facture/escompte-fiche.jsp">
                        <input name="classe" type="hidden" id="classe" value="facture.tr.Escompte">
                        <input name="nomtable" type="hidden" id="nomtable" value="ESCOMPTE">
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
