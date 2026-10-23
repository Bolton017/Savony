<%@ page import="mg.cnaps.compta.BilanCompte" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="mg.cnaps.compta.LigneBilan" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="bean.AdminGen" %>

<%
try{
    String typeetat = request.getParameter("typeetat");
    String annee = request.getParameter("annee");
    BilanCompte bilanCompte = new BilanCompte(typeetat,annee);
    LigneBilan[] cap = Arrays.copyOfRange(bilanCompte.getLigneBilan(),0,6);
    LigneBilan[] noncourants = Arrays.copyOfRange(bilanCompte.getLigneBilan(),6,10);
    LigneBilan[] courants = Arrays.copyOfRange(bilanCompte.getLigneBilan(),10,15);
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Bilan Capitaux Propres et Passif</title>
    <style>
        :root{
            --border:#444;
            --muted:#666;
            --bg:#fff;
            --accent:#111;
        }
        *{box-sizing:border-box}
        body{
            font-family: "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            background: var(--bg);
            color:#111; margin:0; padding:24px;
        }
        .page{
            max-width: 900px; margin: 0 auto; background:#fff;
        }
        h1,h2,h3{margin:0}
        header{ text-align:center; margin-bottom:18px; }
        header h1{ font-size:22px; letter-spacing:.5px; }
        header .subtitle{ color:var(--muted); margin-top:6px; }
        /* Table */
        table{ width:100%; border-collapse:collapse; }
        th, td{ border:1px solid var(--border); padding:8px 10px; vertical-align:top; }
        thead th{ background:#f3f3f3; text-align:center; font-weight:600; }
        .group-title{ background:#f7f7f7; font-weight:700; }
        .right{ text-align:right; }
        .mono{ font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, "Liberation Mono", monospace; }
        .muted{ color:var(--muted); }
        tfoot td{ font-weight:700; background:#fafafa; }
        @media print{
            body{ padding:0 }
            .page{ width:100%; max-width:none; }
        }
    </style>
</head>
<body>
<div class="content-wrapper">
    <header>
        <h1>BILAN CAPITAUX PROPRES ET PASSIF DE <%=annee%></h1>
        <!--div class="subtitle">Exercice clos le&nbsp;: <span class="mono">____ / ____ / ______</span></div-->
    </header>

    <table aria-label="Bilan Passif">
        <thead>
        <tr>
            <th rowspan="2" style="width:36%">CAPITAUX PROPRES ET PASSIF</th>
            <th colspan="3" style="width:64%">COMPTES</th>
        </tr>
        <tr>
            <th style="width:22%">El&eacute;ments additifs</th>
            <th style="width:21%">El&eacute;ments soustractifs</th>
            <th style="width:21%">Montant net</th>
        </tr>
        </thead>
        <tbody>
        <% if (bilanCompte.isSansEcriture()) { %>
        <tr><td colspan="4" style="text-align:center; font-style:italic; color:var(--muted);">Aucune donn&eacute;e disponible pour l&apos;exercice <%= annee %></td></tr>
        <% } %>
        <!-- CAPITAUX PROPRES -->
        <tr>
            <td class="group-title" colspan="4">CAPITAUX PROPRES</td>
        </tr>
        <tr><td>Capital &eacute;mis</td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[0].getValeur1()) %></td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[0].getValeur2()) %></td>
        <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[0].getValeur1() - bilanCompte.getLigneBilan()[0].getValeur2()) %></td>
        </tr>
        <tr>
            <td>Primes et r&eacute;serves consolid&eacute;es</td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[1].getValeur1()) %></td>
            <td></td>
        <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[1].getValeur1()) %></td>
        </tr>
        <tr>
            <td>&Eacute;carts d&apos;&eacute;valuation</td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[2].getValeur1()) %></td>
            <td></td>
        <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[2].getValeur1()) %></td>
        </tr>
        <tr>
            <td>&Eacute;cart d&apos;&eacute;quivalence</td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[3].getValeur1()) %></td>
            <td></td>
        <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[3].getValeur1()) %></td>
        </tr>
        <tr>
            <td>R&eacute;sultat net &ndash; part du groupe</td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[4].getValeur1()) %></td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[4].getValeur2()) %></td>
        <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[4].getValeur1() - bilanCompte.getLigneBilan()[4].getValeur2()) %></td>
        </tr>
        <tr>
            <td>Autres capitaux propres &ndash; report &agrave; nouveau</td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[5].getValeur1()) %></td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[5].getValeur2()) %></td>
        <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[5].getValeur1() - bilanCompte.getLigneBilan()[5].getValeur2()) %></td>
        </tr>
        <tr>
            <td class="right">
                <strong>TOTAL I</strong>
            </td>
            <td class="mono right"><strong><%=Utilitaire.formaterAr(AdminGen.calculSommeDouble(cap,"valeur1"))%></strong></td>
            <td class="mono right"><strong><%=Utilitaire.formaterAr(AdminGen.calculSommeDouble(cap,"valeur2"))%></strong></td>
        <td class="mono right"><strong><%=Utilitaire.formaterAr(AdminGen.calculSommeDouble(cap,"valeur1") - AdminGen.calculSommeDouble(cap,"valeur2"))%></strong></td>
        </tr>

        <!-- PASSIFS NON COURANTS -->
        <tr>
            <td class="group-title" colspan="4">PASSIFS NON COURANTS</td>
        </tr>
        <tr>
            <td>Produits diff&eacute;r&eacute;s : subventions d&apos;investissement</td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[6].getValeur1()) %></td>
            <td></td>
        <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[6].getValeur1()) %></td>
        </tr>
        <tr>
            <td>Imp&ocirc;ts diff&eacute;r&eacute;s</td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[7].getValeur1()) %></td>
            <td></td>
        <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[7].getValeur1()) %></td>
        </tr>
        <tr>
            <td>Emprunts et dettes financi&egrave;res</td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[8].getValeur1()) %></td>
            <td></td>
        <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[8].getValeur1()) %></td>
        </tr>
        <tr>
            <td>Provisions et produits constat&eacute;s d&apos;avance</td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[9].getValeur1()) %></td>
            <td></td>
        <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[9].getValeur1()) %></td>
        </tr>
        <tr>
            <td class="right"><strong>TOTAL PASSIFS NON COURANTS II</strong></td>
            <td class="mono right"><strong><%=Utilitaire.formaterAr(AdminGen.calculSommeDouble(noncourants,"valeur1"))%></strong></td>
            <td class="mono right"><strong><%=Utilitaire.formaterAr(AdminGen.calculSommeDouble(noncourants,"valeur2"))%></strong></td>
        <td class="mono right"><strong><%=Utilitaire.formaterAr(AdminGen.calculSommeDouble(noncourants,"valeur1") - AdminGen.calculSommeDouble(noncourants,"valeur2"))%></strong></td>
        </tr>

        <!-- PASSIFS COURANTS -->
        <tr>
            <td class="group-title" colspan="4">PASSIFS COURANTS</td>
        </tr>
        <tr>
            <td>Dettes court terme &ndash; partie court terme de dettes long terme</td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[10].getValeur1()) %></td>
            <td></td>
        <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[10].getValeur1()) %></td>
        </tr>
        <tr>
            <td>Fournisseurs et comptes rattach&eacute;s</td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[11].getValeur1()) %></td>
            <td></td>
        <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[11].getValeur1()) %></td>
        </tr>
        <tr>
            <td>Provisions et produits constat&eacute;s d&apos;avance &ndash; passifs courants</td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[12].getValeur1()) %></td>
            <td></td>
        <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[12].getValeur1()) %></td>
        </tr>
        <tr>
            <td>Autres dettes</td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[13].getValeur1()) %></td>
            <td></td>
        <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[13].getValeur1()) %></td>
        </tr>
        <tr>
            <td>Comptes de tr&eacute;sorerie (d&eacute;couvert bancaires)</td>
            <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[14].getValeur1()) %></td>
            <td></td>
        <td class="mono"><%=Utilitaire.formaterAr(bilanCompte.getLigneBilan()[14].getValeur1()) %></td>
        </tr>
        <tr>
            <td class="right"><strong>TOTAL PASSIFS COURANTS</strong></td>
            <td class="mono right"><strong><%=Utilitaire.formaterAr(AdminGen.calculSommeDouble(courants,"valeur1"))%></strong></td>
            <td class="mono right"><strong><%=Utilitaire.formaterAr(AdminGen.calculSommeDouble(courants,"valeur2"))%></strong></td>
        <td class="mono right"><strong><%=Utilitaire.formaterAr(AdminGen.calculSommeDouble(courants,"valeur1") - AdminGen.calculSommeDouble(courants,"valeur2"))%></strong></td>
        </tr>
        </tbody>
        <tfoot>
        <tr>
            <td class="right"><strong>TOTAL DES PASSIFS</strong></td>
            <td class="mono right"><strong><%=Utilitaire.formaterAr(AdminGen.calculSommeDouble(bilanCompte.getLigneBilan(),"valeur1"))%></strong></td>
            <td class="mono right"><strong><%=Utilitaire.formaterAr(AdminGen.calculSommeDouble(bilanCompte.getLigneBilan(),"valeur2"))%></strong></td>
        <td class="mono right"><strong><%=Utilitaire.formaterAr(AdminGen.calculSommeDouble(bilanCompte.getLigneBilan(),"valeur1") - AdminGen.calculSommeDouble(bilanCompte.getLigneBilan(),"valeur2"))%></strong></td>
        </tr>
        </tfoot>
    </table>
</div>
</body>
</html>
<%
} catch (Exception e) {
    e.printStackTrace();
} %>