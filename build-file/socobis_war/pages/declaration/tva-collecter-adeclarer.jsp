<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="mg.cnaps.compta.ComptaSousEcritureLib" %>
<%@ page import="utilitaire.*" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDate" %>
;

<% try{
    ComptaSousEcritureLib o = new ComptaSousEcritureLib();
    o.setNomTable("COMPTASOUSECRITURECND");
    String[] listeCrt = {"id","numero","journal","compte","libellePiece","remarque","debit","credit","daty"};
    String[] listeInt = {"daty"};
    String[] libEntete = {"id","numero","journal","compte","daty","libellePiece","remarque","credit"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste des &eacute;critures collect&eacute;es &agrave; d&eacute;clarer");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    String paramSup = "&datydebut="+request.getParameter("datydebut");
    paramSup += "&datyfin="+request.getParameter("datyfin");
    paramSup += "&designation="+request.getParameter("designation");
    paramSup += "&idsOrigin="+request.getParameter("idsOrigin");
    paramSup += "&totalcollecter="+request.getParameter("totalcollecter");
    pr.setApres("declaration/tva-collecter-adeclarer.jsp"+paramSup);
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("numero").setLibelle("Intitul&eacute;");
    pr.getFormu().getChamp("journal").setLibelle("Journal");
    pr.getFormu().getChamp("compte").setLibelle("Compte");
    pr.getFormu().getChamp("libellePiece").setLibelle("Pi&egrave;ce");
    pr.getFormu().getChamp("remarque").setLibelle("Libell&eacute;");
    pr.getFormu().getChamp("debit").setVisible(false);
    pr.getFormu().getChamp("credit").setLibelle("Cr&eacute;dit");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty2").setLibelle("Date max");


    String mois = request.getParameter("mois");
    String annee = request.getParameter("annee");
    Date debut = Utilitaire.getDebutDuMoisByMoisAnnee(Integer.valueOf(mois), Integer.valueOf(annee));
    Date fin = Utilitaire.getFinDuMoisByMoisAnnee(Integer.valueOf(mois), Integer.valueOf(annee));


    pr.getFormu().getChamp("daty1").setDefaut(Utilitaire.formatterDatySql(debut));
    pr.getFormu().getChamp("daty2").setDefaut(Utilitaire.formatterDatySql(fin));

    String[] colSomme = {"credit"};
    pr.setNpp(9999);
    pr.creerObjetPage(libEntete, colSomme);

    String[] libEnteteAffiche = {"Id","Intitul&eacute;","Journal","Compte","Date","Pi&egrave;ce","Libell&eacute;","Montant"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String libRecap[] = {"", "Nombre", "Somme des montants"};
    pr.getTableauRecap().setLibeEntete(libRecap);

%>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post">
            <input type="hidden" name="mois" value="<%=mois%>">
            <input type="hidden" name="annee" value="<%=annee%>">
            <input type="hidden" name="datydebut" value="<%=request.getParameter("datydebut")%>">
            <input type="hidden" name="datyfin" value="<%=request.getParameter("datyfin")%>">
            <input type="hidden" name="idsOrigin" value="<%=request.getParameter("idsOrigin")%>">
            <input type="hidden" name="totalcollecter" value="<%=request.getParameter("totalcollecter")%>">
            <input type="hidden" name="designation" value="<%=request.getParameter("designation")%>">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        
        <%
            out.println(pr.getTableauRecap().getHtml());
        %>
        <br>
        <form action="<%= pr.getLien()+"?but=declaration/apresDeclarerTva.jsp"%>" method="post">
            <div class="row" >
               <div class="col-md-3" style="margin-bottom: 15px;" >
                        <label class="input-label" for="totalcollecter" >Total</label>
                        <input class="form-control" id="totalcollecter" name="totalcollecter" type="text" readonly value="0" readonly>
                </div>
            </div>
          <input type="hidden" value="declaration/tva-deductible-adeclarer.jsp" name="bute" id="bute">
          <input type="hidden" value="true" name="estOrigin" id="estOrigin">
            <input type="hidden" value="<%=Utilitaire.formatterDatySql(debut)%>" name="datydebut" id="datydebut">
            <input type="hidden" value="<%=Utilitaire.formatterDatySql(fin)%>" name="datyfin" id="datyfin">
            <input type="hidden" value="<%=request.getParameter("designation")%>" name="designation" id="designation">
            <%
                pr.getTableau().setNameBoutton("D&eacute;clarer");
                out.println(pr.getTableau().getHtmlWithCheckbox());
                out.println(pr.getBasPage());
            %>
        </form>
    </section>
</div>

<% } catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
history.back();
</script>
<% }%>

<script>
    document.addEventListener("DOMContentLoaded", function () {

        function parseMontant(text) {
            if (!text) return 0;
            return parseFloat(
                text.replace(/\u00a0/g, '')
                    .replace(/\s/g, '')
            ) || 0;
        }

        window.recalculerTotaux = function () {
            let total = 0;

            document.querySelectorAll('input[type="checkbox"][name="ids"]:checked')
                .forEach(cb => {
                    const tr = cb.closest("tr");
                    const tds = tr.querySelectorAll("td");
                    const montantText = tds[8]?.innerText || "0";

                    total  += parseMontant(montantText);
                });

            const totalcollecter = total ;
          document.getElementById("totalcollecter").value       = totalcollecter.toLocaleString('fr-FR');
        };

        document.addEventListener("change", function (e) {
            if (e.target.matches('input[type="checkbox"][name="ids"]')) {
                recalculerTotaux();
            }
        });

        if (typeof window.CocheToutCheckbox === "function") {
            const originalCocheTout = window.CocheToutCheckbox;

            window.CocheToutCheckbox = function () {
                originalCocheTout.apply(this, arguments);
                recalculerTotaux();
            };
        }

    });
</script>
