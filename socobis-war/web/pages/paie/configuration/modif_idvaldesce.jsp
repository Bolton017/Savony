<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<!--FICHIER TOJO And-->
<%!
  UserEJB u;
%>
<%
  String nomtable = request.getParameter("ciblename");
  TypeObjet p = new TypeObjet();
  p.setNomTable(nomtable);
  u = (user.UserEJB) session.getValue("u");
  PageUpdate pc = new PageUpdate(p, request, (user.UserEJB) session.getValue("u"));//ou avec argument liste Libelle si besoin

  String titre = request.getParameter("ciblename");
  if (titre.compareToIgnoreCase("BUDGET_CATEGORIE_REJET_OP") == 0) {
    titre = "Categorie rejet OP";
  }

  String val = "Libell&eacute;";
  String desce = "Description";

  if (request.getParameter("value") != null && request.getParameter("value").compareToIgnoreCase("") != 0) {
    val = request.getParameter("value");
  }
  if (request.getParameter("description") != null && request.getParameter("description").compareToIgnoreCase("") != 0) {
    desce = request.getParameter("description");
  }

  if (nomtable.equalsIgnoreCase("cooperative")) {
    affichage.Champ[] liste = new affichage.Champ[1];
    TypeObjet t = new TypeObjet();
    t.setNomTable("zones");
    liste[0] = new Liste("desce", t, "val", "id");
    pc.getFormu().changerEnChamp(liste);
  }
  if (nomtable.equalsIgnoreCase("ligne")) {
    affichage.Champ[] liste = new affichage.Champ[1];
    TypeObjet t = new TypeObjet();
    t.setNomTable("cooperative");
    liste[0] = new Liste("desce", t, "val", "id");
    pc.getFormu().changerEnChamp(liste);
  }
  if (nomtable.equalsIgnoreCase("province")) {
    titre = "Ville";
    affichage.Champ[] liste = new affichage.Champ[1];
    TypeObjet t = new TypeObjet();
    t.setNomTable("type_province");
    liste[0] = new Liste("desce", t, "val", "id");
    pc.getFormu().changerEnChamp(liste);
  }
  if (nomtable.equalsIgnoreCase("formation_diplome")) {
    titre = "Formation Diplome";
  }

if (nomtable.equalsIgnoreCase("modepaiement")) {
    titre = "Modification du mode de paiement";
}
  if (nomtable.equalsIgnoreCase("poste")) {
    titre = "Poste";
  }
  pc.getFormu().getChamp("id").setVisible(false);
  pc.getFormu().getChamp("val").setLibelle("Libell&eacute;");
  pc.getFormu().getChamp("desce").setLibelle(desce);

  pc.preparerDataFormu();

%>
<style>
    .col-md-12.cardradius.input-container {
        border: none;
        border-top: none !important;
        padding: 8px 0;
        margin-top: 0;
    }
      .box-footer{
        border-top: none;
    }


</style>
<div class="content-wrapper">
    <h1 class="box-title"><%= titre %>></h1>
    <div class="cardradius">
        <form action="<%=(String) session.getValue("lien")%>?but=paie/configuration/apresIdvaldesce.jsp" method="post" name="configuration" id="idvaldesce">
            <div class="box-body">
                <%
                    out.println(pc.getFormu().getHtmlInsert());
                %>
            </div>
            <div class="box-footer">
                <button type="submit" name="Submit2" value="Modifier" class="btn btn-primary pull-right" style="margin-left: 8px">
                    <i class="fa fa-save"></i> Modifier
                </button>

                <button type="submit" name="Submit2" value="Supprimer" class="btn btn-danger pull-left"
                        onclick="if(confirm('Êtes-vous sûr de vouloir supprimer cet élément?')) { document.getElementById('acte').value = 'delete'; } else { return false; }">
                    <i class="fa fa-trash"></i> Supprimer
                </button>

                <a href="<%=(String) session.getValue("lien")%>?but=paie/configuration/idvaldesce.jsp&ciblename=<%out.print(nomtable);%>&value=<%=val%>&description=<%=desce%>"
                   class="btn btn-secondary btn-danger pull-right">
                    <i class="fa fa-times"></i> Annuler
                </a>
            </div>

            <!-- Hidden fields -->
            <input name="acte" type="hidden" id="acte" value="update">
            <input name="nomtable" type="hidden" id="nomtable" value="<%=nomtable%>">
            <input name="bute" type="hidden" id="bute" value="paie/configuration/idvaldesce.jsp&ciblename=<%=nomtable%>&value=<%=val%>&description=<%=desce%>">
            <input name="classe" type="hidden" id="classe" value="bean.TypeObjet">
        </form>
    </div>
</div>