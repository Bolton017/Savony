<%@page import="paie.ostie.OstieAffiche"%>
<%@page import="paie.log.LogPersonnelFin"%>
<%@page import="bean.TypeObjet"%>
<%@page import="affichage.Liste"%>
<%@page import="affichage.PageRecherche"%>
<%@page import="utilitaire.Utilitaire"%>

<%
    OstieAffiche dr = new OstieAffiche();
    dr.setDirection("DIR00001");
    if (request.getParameter("etat") != null && !request.getParameter("etat").equals("")) {
        dr.setNomTable(request.getParameter("etat"));
    } else {
        dr.setNomTable("v1_ostie_affiche_t1");
    }
    String listeCrt[] = {"nom", "prenoms", "sexe", "date_naissance", "fonction", "dateembauche"};
    String listeInt[] = {};
    String libEntete[] = {"matricule", "nom", "prenoms","sexe","date_naissance","dateembauche", "date_depart", "fonction", "cnaps","cin",
        "mois1", "mois2", "mois3",
        "salaires_non_plafonnes", "salaires_plafonnes", "employeur", "travailleur", "total"};
    PageRecherche pr = new PageRecherche(dr, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));

    Liste[] liste = new Liste[1];
    TypeObjet fonc = new TypeObjet();
    fonc.setNomTable("PAIE_FONCTION");
    liste[0] = new Liste("fonction", fonc, "val", "val");

    pr.getFormu().changerEnChamp(liste);

    pr.getFormu().getChamp("sexe").setLibelle("Genre");
    pr.getFormu().getChamp("date_naissance").setLibelle("Date de naissance");
    pr.getFormu().getChamp("date_naissance").setDefaut(utilitaire.Utilitaire.dateDuJour() + "");
    pr.getFormu().getChamp("dateembauche").setLibelle("Date embauche");
    pr.getFormu().getChamp("dateembauche").setDefaut(utilitaire.Utilitaire.dateDuJour() + "");


    pr.setApres("paie/ostie/ostieaffiche.jsp");
    pr.setTitre("OSTIE");
    String[] colSomme = {"travailleur", "employeur", "total"};
    pr.creerObjetPage(libEntete, colSomme);
    pr.getFormu().setAnotherButton("<button type=\"button\" class=\"btn btn-primary btn-small \" onclick=\"document.getElementById('exportExcelForm').submit()\"> Exporter en Excel Directement</button>");
%>
<script>
    function changerDesignation() {
        document.personnel.submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1>OSTIE</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=paie/ostie/ostieaffiche.jsp" method="post" name="personnel" id="personnel">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <div class="row col-md-12">
                <div class="col-md-4">
                    <div class="form-group">
                        <label for="etat">Trimestre : </label>
                        <select name="etat" class="champ form-control" id="etat" onchange="changerDesignation()" >
                            <option value="v1_ostie_affiche_t1" <% if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("v1_ostie_affiche_t1") == 0) {
                                out.print(" selected");
                            }%>>1er trimestre</option>
                            <option value="v1_ostie_affiche_t2" <%if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("v1_ostie_affiche_t2") == 0) {
                                out.print("selected");
                            }%>>2eme trimestre</option>
                            <option value="v1_ostie_affiche_t3" <%if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("v1_ostie_affiche_t3") == 0) {
                                out.print("selected");
                            }%>>3eme trimestre</option>
                            <option value="v1_ostie_affiche_t4" <%if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("v1_ostie_affiche_t4") == 0) {
                                out.print("selected");
                            }%>>4eme trimestre</option>
                        </select>
                    </div>
                </div>
            </div>
        </form>
        
        <%
            out.println(pr.getTableauRecap().getHtml());    
        %>
        <center>
            <div class="d-flex justify-content-end mb-3 d-none">
                <form id="exportExcelForm" action="../ExportDispatcher"  method="post" class="form-inline" >
                    <input type="hidden" name="action" value="ostie">
<%--                  <button type="submit" name="Submit" class="btn btn-success"> Exporter </button>--%>
                </form>
              </div>
        </center>
        
        <br>
        <%
            String libEnteteAffiche[] = {"Matricule", "Nom", "Prenoms","Sexe","Date naissance","Date embauche", "Date depart", "Fonction", "Cnaps","Cin",
        "Mois1", "Mois2", "Mois3",
        "Salaires non plafonnes", "Salaires plafonnes", "Employeur", "Travailleur", "Total"};
            pr.getTableau().setLibelleAffiche(libEnteteAffiche);
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
        
<!-- Barre d?outils align�e � droite -->




    </section>
</div>
