<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="mg.vola.dao.TransactionDAO" %>
<%@ page import="mg.vola.models.Recette" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tableau de Bord - Recettes M-Vola</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        body { background-color: #f8f9fa; }
        .card-stat { border-radius: 15px; border: none; transition: transform 0.2s; }
        .card-stat:hover { transform: translateY(-5px); }
        .icon-box { width: 50px; height: 50px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 24px; }
    </style>
</head>
<body>

<nav class="navbar navbar-dark bg-primary mb-4">
    <div class="container">
        <span class="navbar-brand mb-0 h1"><i class="bi bi-wallet2 me-2"></i> M-Vola Admin - Recettes</span>
        <a href="transaction.jsp" class="btn btn-outline-light btn-sm">Retour aux Transactions</a>
    </div>
</nav>

<div class="container">
    <%
        TransactionDAO dao = new TransactionDAO();
        // Imaginons que tu as créé cette méthode dans ton DAO
        Recette rec = dao.calculerRecettesGlobales(); 
    %>

    <div class="row g-4 mb-5">
        <div class="col-md-4">
            <div class="card card-stat shadow-sm p-4 bg-primary text-white">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-uppercase mb-1" style="opacity: 0.8;">Recette Totale Encaissée</h6>
                        <h2 class="fw-bold mb-0"><%= String.format("%, d", rec.getBeneficeTotal()) %> Ar</h2>
                    </div>
                    <div class="icon-box bg-white text-primary">
                        <i class="bi bi-cash-stack"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card card-stat shadow-sm p-4 bg-white">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-muted text-uppercase mb-1">Commissions Envois</h6>
                        <h2 class="fw-bold mb-0 text-dark"><%= String.format("%, d", rec.getTotalFraisEnvoi()) %> Ar</h2>
                    </div>
                    <div class="icon-box bg-light text-success">
                        <i class="bi bi-arrow-up-right-circle"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card card-stat shadow-sm p-4 bg-white">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-muted text-uppercase mb-1">Commissions Retraits</h6>
                        <h2 class="fw-bold mb-0 text-dark"><%= String.format("%, d", rec.getTotalFraisRetrait()) %> Ar</h2>
                    </div>
                    <div class="icon-box bg-light text-danger">
                        <i class="bi bi-arrow-down-left-circle"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-8">
            <div class="card border-0 shadow-sm p-4 mb-4" style="border-radius: 15px;">
                <h5 class="fw-bold mb-4">Détails de la comptabilité</h5>
                <table class="table table-hover">
                    <thead class="table-light">
                        <tr>
                            <th>Type de Frais</th>
                            <th>Description</th>
                            <th class="text-end">Montant Cumulé</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><span class="badge bg-success-subtle text-success p-2">Envoi</span></td>
                            <td>Frais payés directement par l'envoyeur</td>
                            <td class="text-end fw-bold"><%= String.format("%, d", rec.getTotalFraisEnvoi()) %> Ar</td>
                        </tr>
                        <tr>
                            <td><span class="badge bg-danger-subtle text-danger p-2">Retrait</span></td>
                            <td>Frais déduits lors de la réception physique</td>
                            <td class="text-end fw-bold"><%= String.format("%, d", rec.getTotalFraisRetrait()) %> Ar</td>
                        </tr>
                    </tbody>
                    <tfoot class="table-light">
                        <tr>
                            <td colspan="2" class="fw-bold">Bénéfice Net Actuel</td>
                            <td class="text-end text-primary fw-bold h5"><%= String.format("%, d", rec.getBeneficeTotal()) %> Ar</td>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card border-0 shadow-sm p-4 bg-light" style="border-radius: 15px;">
                <h6 class="fw-bold"><i class="bi bi-info-circle me-2"></i>Note sur les calculs</h6>
                <p class="small text-muted">
                    Les recettes affichées ici correspondent aux frais **réellement prélevés** en base de données. 
                    Si un envoyeur a payé les frais de retrait à l'avance, ils n'apparaissent dans la colonne "Retrait" que lorsque le destinataire retire l'argent.
                </p>
                <hr>
                <button class="btn btn-primary w-100 py-2" onclick="window.print()">
                    <i class="bi bi-printer me-2"></i>Imprimer le rapport
                </button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>