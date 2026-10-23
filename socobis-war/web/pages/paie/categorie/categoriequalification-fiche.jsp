<%@page import="paie.CategorieQualification"%>
<%@page import="affichage.PageConsulte"%>
<%@page import="user.UserEJB"%>
<%@page import="service.UploadService"%>
<%
    try {
        //Onglets
        String tab = null;
        String id = request.getParameter("id");

        UserEJB u = (UserEJB) session.getAttribute("u");
        CategorieQualification categorie = new CategorieQualification();
        categorie.setNomTable("categ_qualilibcomplet");
        PageConsulte pc = new PageConsulte(categorie, request, u);
        pc.setTitre("Fiche cat&eacute;gorie qualification");
        pc.getChampByName("idcategorie").setLibelle("Cat&eacute;gorie");
        pc.getChampByName("nomCpl").setLibelle("Personnel");
        pc.getChampByName("matricule").setLibelle("Matricule");
        pc.getChampByName("etatval").setVisible(false);
        pc.getChampByName("etatlibelle").setVisible(false);
        
        pc.getChampByName("prenom").setLibelle("Pr&eacute;nom");
        pc.getChampByName("prenom").setVisible(false);
        pc.getChampByName("idqualification").setLibelle("Qualification");
        pc.getChampByName("date_debut").setLibelle("Date D&eacute;but");
        pc.getChampByName("date_fin").setLibelle("Date Fin");
        pc.getChampByName("etat").setVisible(false);
        
        categorie = (CategorieQualification) pc.getBase();

        pc.getChampByName("remarque").setLibelle("ID Personnel");
        pc.getChampByName("remarque").setLien("?but=paie/employe/personnel-fiche-portrait.jsp", "id=");

        String pageActuel = "paie/categorie/categoriequalification-fiche.jsp";
        String classe = "paie.CategorieQualification";
%>

<div class="content-wrapper">
    <h1 class="box-title"><a href="<%=(String) session.getValue("lien")%>?but=compta/exercice/ouvertureCloture.jsp"><i class="fa fa-angle-left"></i></a><%=pc.getTitre()%>
    </h1>
    <div class="row m-0">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        </br>
                        <div class="box-footer">
                            <a class="btn btn-secondary pull-right"  href="<%=(String) session.getValue("lien") + "?but=paie/categorie/categoriequalification-saisie.jsp&id=" + id + "&acte=update"%>" style="margin-right: 10px">Modifier</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    $('#fiche .row .col-md-6').removeClass('col-md-6').removeClass('col-md-center').addClass('col-md-8').addClass('col-md-offset-2');
</script>
<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> 
    alert('<%=e.getMessage()%>');
    history.back();
    
</script>

<% }%>
