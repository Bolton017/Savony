<%-- 
    Document   : planremboursement-saisie
    Created on : 10 d�c. 2020, 16:05:13
    Author     : Sanda
--%>

<%@page import="bean.CGenUtil"%>
<%@page import="affichage.PageConsulte"%>
<%@page import="paie.avance.Avance"%>
<%@page import="utilitaire.Utilitaire"%> 
<%@page import="paie.avance.Remboursement"%>

<%
    try{
        String lien = (String)session.getAttribute("lien");
        String id = request.getParameter("id"),
       nb_Remboursement = request.getParameter("nbremboursement"),
            colonneMere = request.getParameter("idpersonnel"),
            classeFille = "paie.avance.Remboursement",
            redirection = "paie/avance/remboursement-modif.jsp";

        Avance base = new Avance();
        base.setNomTable("AVANCE_LIB");
        PageConsulte pc = new PageConsulte(base, request, (user.UserEJB) session.getValue("u"));
        pc.getChampByName("daty").setVisible(false);

        pc.getChampByName("idpersonnel").setLibelle("Personnel");
        pc.getChampByName("nbremboursement").setLibelle("Nombre de remboursements");
//        pc.getChampByName("daty").setLibelle("Date");
        pc.getChampByName("dateavance").setLibelle("Date avance");
        pc.getChampByName("idtypeavance").setLibelle("Type");

	pc.setTitre("Fiche Avance");
        base = (Avance) pc.getBase();        
        
        Remboursement fille = new Remboursement();
        String [] mois = {"Janvier","Fevrier","Mars","Avril","Mai","Juin","Juillet","Aout","Septembre","Octobre","Novembre","Decembre"};
        int finMois = mois.length;
        fille.setNomTable("remboursement");
        String idMere =  request.getParameter("idMere") == null   ? id : request.getParameter("idMere") ;
        fille.setIdavance(idMere);
//        Remboursement[] lsP =  (Remboursement[]) CGenUtil.rechercher(fille, null, null, "");
        Remboursement[] lsP =  fille.listPlanRemb("",null);
        int nbremboursement = lsP== null ? 0 : lsP.length ;
%>
<div class="content-wrapper">
    <div class="row">
        <h1>Modification de plan remboursement</h1>
        <%
            out.println(pc.getHtml());
        %>
        <form class='container' action="<%=lien%>?but=apresTarifMultiple.jsp" method="post" name="remboursement" id="remboursement">
            <div class="col-md-10">
                <div class="box box-primary">
                    <div class="box-body">
                        <table class="table table-bordered table-condensed">
                            <thead>
                                <tr>
                                    <th>Mois</th>
                                    <th>Annee</th>
                                    <th>Montant</th>
                                </tr>
                            </thead>
                            <tbody id="">
                                <%for(int i=0;i<nbremboursement;i++){%>
                                    <tr id="ligne-id-<%=i%>">
                                        <input class="form-control" id="iddemande<%=i%>" name="iddemande<%=i%>" value="<%=id%>"  type="hidden">
                                        <td>
                                            <select name="mois<%=i%>" class="champ" id="mois<%=i%>" >
                                                <%for(int j=0;j<finMois;j++){%>
                                                    <option value="<%=j+1%>"  <%= lsP[i].getMois() == j+1 ? "selected" : "" %>   ><%=mois[j]%></option>
                                                <%}%>
                                            </select>
                                        </td>
                                        <td><input class="form-control" id="annee<%=i%>" name="annee<%=i%>"  value="<%= lsP[i].getAnnee() %>" type="number"></td>
                                        <td><input class="form-control" id="montant<%=i%>" name="montant<%=i%>"  value="<%= lsP[i].getMontant()%>"  type="number"></td>
                                    </tr>
                                <%}%>
                            </tbody>
                        </table>
                    <input name="idMere" type="hidden" id="nature" value="<%=base.getId() %>">
                    <input name="acte" type="hidden" id="nature" value="savePlanRemboursement">
                    <input name="action" type="hidden" id="nature" value="update">
                    <input name="bute" type="hidden" id="bute" value="<%=redirection%>">
                    <input name="classefille" type="hidden" id="classefille" value="<%=classeFille%>">
                    <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%=nbremboursement%>">
                    <input name="colonneMere" type="hidden" id="colonneMere" value="<%=colonneMere%>">
                    <input type="submit" class="btn btn-success pull-right" value="Enregistrer">
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>
<%
    } catch (Exception e) {
        e.printStackTrace();
%>
<script language="JavaScript">
    alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>
