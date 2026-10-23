<%@page import="affichage.Liste"%>
<%@page import="bean.TypeObjet"%>
<%@page import="paie.employe.PaieAvancementLibelle"%>
<%@page import="affichage.PageRecherche"%>
<% PaieAvancementLibelle lv = new PaieAvancementLibelle();
    if (request.getParameter("etat") != null && !request.getParameter("etat").equals("")) {
        lv.setNomTable(request.getParameter("etat"));
    } else {
        lv.setNomTable("PAIE_AVANCEMENT_LIBELLE2");
    }
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {"id", "matricule", "id_logpers", "direction", "service","motif","idfonction", "datedecision", "date_application"};
    PageRecherche pr = new PageRecherche(lv, request, listeCrt, listeInt, 3, libEntete, 8);

    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("paie/avancement/avancement-liste.jsp");
    String apresWhere=" and idpers='"+request.getParameter("id")+"'";
    pr.setAWhere(apresWhere);
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);%>


<script>
    function changerDesignation() {
        document.prestation.submit();
    }
</script>

<div class="row">
    <div class="col-md-12">
        <div class="box box-primary box-fiche">
            <div class="box-header with-border">
                <h1 class="box-title">Historique</h1>
            </div>
            <div class="box-body">
            <%
                String libEnteteAffiche[] = {"id", "Matricule", "Nom et pr&eacute;noms", "Exploitation", "Section","Motif", "Fonction", "Date d&eacute;cision", "Date application"};
                pr.getTableau().setLibelleAffiche(libEnteteAffiche);
                out.println(pr.getTableau().getHtml());
            %>
            </div>
        </div>
    </div>
</div>
