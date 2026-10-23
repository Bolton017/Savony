<%@page import="paie.CategorieQualification"%>
<%@page import="paie.categorie.SalaireCategorie"%>
<%@page import="affichage.PageConsulte"%>
<%@page import="user.UserEJB"%>
<%@page import="service.UploadService"%>
<%
    try {
        //Onglets
        String tab = null;
        String id = request.getParameter("id");

        UserEJB u = (UserEJB) session.getAttribute("u");
        SalaireCategorie categorie = new SalaireCategorie();
        categorie.setNomTable("CATEGORIE_QUALIFICATION_VW");
        PageConsulte pc = new PageConsulte(categorie, request, u);
        pc.setTitre("Fiche salaire par cat&eacute;gorie");
        pc.getChampByName("categorie_libelle").setLibelle("Cat&eacute;gorie");
        pc.getChampByName("idCategorie").setVisible(false);
        pc.getChampByName("idQualification").setVisible(false);
        pc.getChampByName("montant").setLibelle("Montant du salaire");
        pc.getChampByName("qualification_libelle").setLibelle("Classification");
        pc.getChampByName("date_debut").setLibelle("Date D&eacute;but");
        pc.getChampByName("date_fin").setLibelle("Date Fin");
        
        categorie = (SalaireCategorie) pc.getBase();


        String pageActuel = "paie/categorie/SalaireCategorie-fiche.jsp";
        String classe = "paie.categorie.SalaireCategorie";
%>

<div class="content-wrapper">
    <h1 class="box-title"><a href="<%=(String) session.getValue("lien")%>?but=paie/categorie/categoriequalification-liste.jsp"><i class="fa fa-angle-left"></i></a><%=pc.getTitre()%>
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
