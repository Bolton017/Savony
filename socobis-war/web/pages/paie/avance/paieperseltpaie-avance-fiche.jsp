<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="user.UserEJB" %>
<%@ page import="paie.elementpaie.PaiePersonnelElementpaie" %>
<%@ page import="affichage.PageConsulte" %>

<%
    try {

        String autreparsley = "data-parsley-range='[8, 40]' required";
        String lien = (String) session.getValue("lien");
        String pageModif = "paie/avance/paieperseltpaie-avance-saisie.jsp";
        String classe = "paie.elementpaie.PaiePersonnelElementpaie";
        String id = request.getParameter("id");
        String pageActuel = "paie/fonction/paiepersonnelelementpaie-fiche.jsp";

        UserEJB u = (user.UserEJB) session.getValue("u");
        String  nomtable = "paie_personnel_elementpaie_lib";

        PaiePersonnelElementpaie objet = new PaiePersonnelElementpaie();
        objet.setNomTable(nomtable);

        PageConsulte pc = new PageConsulte(objet, request, u);
        pc.setTitre("Fiche De L'&eacute;l&eacute;ment De Paie Du Personnel");

        pc.getChampByName("code_rubrique").setLibelle("Code Rubrique");
        pc.getChampByName("date_debut").setLibelle("Date De D&eacute;but");
        pc.getChampByName("date_fin").setLibelle("Date De Fin");
        pc.getChampByName("idpersonnel").setLibelle("Personnel");
        pc.getChampByName("moisregularisation").setLibelle("Mois de R&eacute;gularisation");
        pc.getChampByName("anneeregularisation").setLibelle("Ann&eacute;e de r&eacute;gularisation");
        pc.getChampByName("idcategorie_qualification").setVisible(false);
        pc.getChampByName("iduser").setVisible(false);
        pc.getChampByName("id_objet").setVisible(false);
        pc.getChampByName("idfonction").setVisible(false);
        pc.getChampByName("pourcentage").setVisible(false);
        pc.getChampByName("etat").setLibelle("&Eacute;tat");
        
        PaiePersonnelElementpaie base = (PaiePersonnelElementpaie) pc.getBase();
%>

<div class="content-wrapper">
    <h1 class="box-title"><a href="#"><i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>
    <div class="row m-0">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box mb-5">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>

                        <% if (base.getEtat() < 11) { %>
                            <div class="box-footer">
                                <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute="+pageActuel+"&classe=" + classe%> " style="margin-right: 10px">Viser</a>

                                <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id + "&acte=update"%>" style="margin-right: 10px">Modifier</a>

                                <a class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=#&classe="+classe %>">Supprimer</a>
                            </div>
                        <% } %>
                        <br/>

                    </div>
                </div>
            </div>
            <%=pc.getHtmlAttacherFichier()%>
        </div>
    </div>
</div>


<%
    } catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript">
    alert('<%=e.getMessage()%>');
    history.back();</script>
<% }%>