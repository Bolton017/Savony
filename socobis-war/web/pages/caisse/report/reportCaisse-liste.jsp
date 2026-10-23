

<%@page import="caisse.ReportCaisseCpl"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>

<% try{
    ReportCaisseCpl t = new ReportCaisseCpl();
    String listeCrt[] = {"id","daty","idCaisseLib","montant","montantTheorique"};
    String listeInt[] = {"daty","montant","montantTheorique"};
    String libEntete[] = {"id","daty","heure","idCaisseLib","montant","montantTheorique","ecartCalc", "etatLib"};
    String etat = request.getParameter("etat");
    if(etat == null) etat = "";
    t.setNomTable( t.getNomTable().concat(etat) );
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Historique de report caisse");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("caisse/report/reportCaisse-liste.jsp");
    String[] colSomme = {"montant", "montantTheorique"};
    pr.getFormu().getChamp("id").setLibelle("Ref.");
    pr.getFormu().getChamp("idCaisseLib").setLibelle("Tr&eacute;sorerie");
    pr.getFormu().getChamp("montant1").setLibelle("Montant min");
    pr.getFormu().getChamp("montant2").setLibelle("Montant max");
    pr.getFormu().getChamp("montantTheorique1").setLibelle("Montant th&eacute;orique min");
    pr.getFormu().getChamp("montantTheorique2").setLibelle("Montant th&eacute;orique max");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.creerObjetPage(libEntete, colSomme);

    Map<String,String> lienTab=new HashMap();
    lienTab.put("modifier",pr.getLien() + "?but=caisse/report/reportCaisse-modif.jsp");
    String classe = "caisse.ReportCaisse";
    lienTab.put("viser",pr.getLien() + "?but=apresTarif.jsp&acte=valider&bute=caisse/report/reportCaisse-liste.jsp&classe=" + classe);
    lienTab.put("dupliquer",pr.getLien() + "?but=apresTarif.jsp&acte=dupliquerSimple&classe=caisse.ReportCaisse&nomtable=REPORTCAISSE&bute=caisse/report/reportCaisse-liste.jsp");
    pr.getTableau().setLienClicDroite(lienTab);

    String lienTableau[] = {pr.getLien() + "?but=caisse/report/reportCaisse-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"Ref.","date", "Heure", "Tr&eacute;sorerie","montant","Montant th&eacute;orique ","&Eacute;cart","&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String[] etatAffiche = {"Tous","Cr&eacute;&eacute;(s)","Valid&eacute;(s)","Annul&eacute;(s)"};
    String[] etatPasse = {"","_cree","_valider", "_annule"};
    pr.getFormu().setAnotherButton("" +
    "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=caisse/report/reportCaisse-saisie.jsp\">\n" +
    "                    <i class=\"material-symbols-rounded\">add</i>Saisie report de tr&eacute;sorerie</a>"
    );
    pr.getTableauRecap().setLibeEntete(new String[]{"","Nombre","Somme des Montants", "Somme des Montants Th&eacute;oriques"});

%>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" name="vente" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <div class="row col-md-12 nopadding">
                    <div class="col-md-4 nopadding">
                            <label for="etat" class="input-label">&Eacute;tat</label>
                            <select name="etat" id="etat" class="form-control" onchange="changerDesignation()">
                                <%
                                    for(int i=0; i<etatAffiche.length; i++){
                                        String selected = "";
                                        if(request.getParameter("etat")!=null && request.getParameter("etat").compareToIgnoreCase(etatPasse[i])==0){
                                            selected = "selected";
                                        }
                                %>
                                <option value="<%=etatPasse[i]%>" <%=selected%>><%=etatAffiche[i]%></option>
                                <%
                                    }
                                %>
                            </select>
                    </div>
            </div>
        </form>

        <div class="col-md-12 nopadding">
            <%
                out.println(pr.getTableauRecap().getHtml());
            %>
        </div>

        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<script>
    function changerDesignation() {
        document.vente.submit();
    }
</script>
    <%
    }catch(Exception e){

        e.printStackTrace();
    }
%>



