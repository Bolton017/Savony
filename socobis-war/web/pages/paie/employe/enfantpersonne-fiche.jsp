<%@page import="paie.employe.EnfantPersonnelCpl"%>
<%@page import="utilitaire.ConstanteEtatPaie"%>
<%@page import="bean.CGenUtil"%>
<%@page import="user.UserEJB"%>
<%@page import="affichage.PageConsulte"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%!
    EnfantPersonnelCpl personnel;
    PageConsulte pc;
    UserEJB u = null;
    String lien = null;
    String id = null;
%>
<%
    try {
        u = (UserEJB) session.getAttribute("u");
        lien = (String) session.getValue("lien");
        personnel = new EnfantPersonnelCpl();
        pc = new PageConsulte(personnel, request, (user.UserEJB) session.getValue("u"));
        personnel = (EnfantPersonnelCpl) pc.getBase();
        pc.setTitre("Fiche enfant");
        pc.getChampByName("id").setLibelle("ID");
        pc.getChampByName("nom").setLibelle("Nom");
        pc.getChampByName("dateNaissance").setLibelle("Date de naissance");
        pc.getChampByName("matricule").setLibelle("Matricule");
        pc.getChampByName("age").setLibelle("Age");
        pc.getChampByName("idPersonnel").setVisible(false);
        pc.getChampByName("nomPersonnel").setVisible(false);
%>

<div class="content-wrapper">
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                     <%
                            out.println(pc.getHtml());
                       %>
                       
                </div>
                 <a class="btn btn-warning pull-left"  href="<%= lien + "?but=paie/employe/enfantpersonne-saisie.jsp&id=" +personnel.getId()+"&acte=update" %>" style="margin-right: 10px">Modifier</a>
                               
            </div>
        </div>
    </div>
    
    </div>
</div>

<%
    }catch(Exception e){
        e.printStackTrace();
    }
%>