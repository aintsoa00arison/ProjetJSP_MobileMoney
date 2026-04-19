<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, mg.vola.models.*, mg.vola.dao.*" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NovaCash | Terminal de Flux</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

    <style>
        :root {
            --main-dark: #0F172A;
            --accent-mint: #2DD4BF;
            --accent-rose: #F43F5E;
            --bg-page: #F1F5F9;
            --soft-radius: 12px;
            --border-color: #E2E8F0;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--bg-page);
            color: var(--main-dark);
        }

        /* --- HEADER SECTION --- */
        .header-card {
            background: white;
            border-left: 6px solid var(--accent-mint);
            border-radius: var(--soft-radius);
        }

        /* --- DASHBOARD CONTAINER & SWITCHER --- */
        .dashboard-container {
            background: white;
            border-radius: var(--soft-radius);
            border: 1px solid var(--border-color);
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(15, 23, 42, 0.05);
        }

        .nav-section-switcher {
            display: flex;
            background: #E2E8F0;
            padding: 6px;
            border-bottom: 1px solid var(--border-color);
        }

        .nav-section-switcher .nav-link {
            flex: 1;
            text-align: center;
            padding: 14px 20px;
            color: #475569;
            font-weight: 600;
            border: none;
            border-radius: 10px;
            transition: all 0.25s ease;
            background: transparent;
        }

        .nav-section-switcher .nav-link:hover:not(.active) {
            background-color: rgba(255, 255, 255, 0.5);
            color: var(--main-dark);
        }

        .nav-section-switcher .nav-link.active {
            background: white;
            color: var(--main-dark);
            box-shadow: 0 4px 12px rgba(15, 23, 42, 0.1);
        }

        .nav-link[data-bs-target="#tab-transfert"].active i { color: var(--accent-mint); }
        .nav-link[data-bs-target="#tab-retrait"].active i { color: var(--accent-rose); }

        /* --- FORMULAIRES --- */
        .form-label { font-size: 0.85rem; font-weight: 600; color: #64748B; margin-bottom: 6px; }

        .form-control, .form-select {
            border-radius: var(--soft-radius);
            padding: 12px 16px;
            border: 1px solid var(--border-color);
            background-color: #F8FAFC;
            transition: all 0.2s;
        }

        .form-control:focus, .form-select:focus {
            background-color: #fff;
            border-color: var(--accent-mint);
            box-shadow: 0 0 0 4px rgba(45, 212, 191, 0.1);
        }

        /* --- TABLEAUX --- */
        .table-vola thead th {
            background-color: transparent;
            color: #64748B;
            font-size: 0.85rem;
            font-weight: 600;
            padding: 12px 16px;
            border-bottom: 2px solid var(--border-color);
        }

        .table-vola tbody td {
            padding: 14px 16px;
            border-bottom: 1px solid #F1F5F9;
            vertical-align: middle;
            font-size: 0.9rem;
            color: #334155;
        }

        .row-env, .row-ret {
            transition: all 0.2s;
            border-left: 3px solid transparent;
        }
        .row-env:hover, .row-ret:hover {
            background-color: #f8fafc;
            border-left: 3px solid var(--accent-mint);
        }

        .badge-frais {
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 600;
        }
        .frais-ok { background: #DCFCE7; color: #166534; }
        .frais-ko { background: #F1F5F9; color: #64748B; }

        .price-up { color: var(--main-dark); font-weight: 600; }
        .price-down { color: var(--accent-rose); font-weight: 600; }

        /* --- BOUTONS --- */
        .btn-action {
            border-radius: var(--soft-radius);
            padding: 12px 24px;
            font-weight: 600;
            transition: 0.3s;
            border: none;
        }
        .btn-mint { background: var(--accent-mint); color: var(--main-dark); }
        .btn-mint:hover { background: #24b8a5; transform: translateY(-2px); }

        /* --- TOAST --- */
        .toast-container { z-index: 1100; }
    </style>
</head>
<body>

<%@ include file="navbar.jsp" %>

<div class="container py-5">

    <div class="header-card shadow-sm p-4 mb-5 d-flex justify-content-between align-items-center">
        <div>
            <h2 class="mb-0 fw-bold">Gestion des Flux</h2>
            <p class="mb-0 text-muted">Contrôle des envois et décaissements NovaCash</p>
        </div>
        <button class="btn px-4 py-2 fw-bold text-white" style="border-radius: 10px; background: linear-gradient(135deg, #EF4444, #B91C1C); border: none;" data-bs-toggle="modal" data-bs-target="#releveModal">
            <i class="bi bi-file-earmark-pdf me-2"></i>Relevé PDF
        </button>
    </div>

    <div class="dashboard-container">

        <nav class="nav nav-section-switcher" id="mainTab" role="tablist">
            <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#tab-transfert" type="button">
                <i class="bi bi-send-fill me-2"></i>Transferts
            </button>
            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-retrait" type="button">
                <i class="bi bi-wallet2 me-2"></i>Retraits
            </button>
        </nav>

        <div class="tab-content p-4">

            <!-- ===== ONGLET TRANSFERTS ===== -->
            <div class="tab-pane fade show active" id="tab-transfert">
                <div class="row g-4">
                    <div class="col-lg-4 border-end">
                        <h6 class="fw-bold mb-4 text-muted small text-uppercase">Nouveau Transfert</h6>
                        <form action="TransactionServlet" method="POST" id="envoiForm">
                            <input type="hidden" name="action" value="envoyer">
                            <div class="mb-3">
                                <label class="form-label">Numéro Expéditeur</label>
                                <input list="listeNumeros" name="numEnvoyeur" class="form-control" placeholder="034..." required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Numéro Bénéficiaire</label>
                                <input list="listeNumeros" name="numRecepteur" class="form-control" placeholder="032..." required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Montant (Ar)</label>
                                <input type="number" name="montant" id="montantE" class="form-control form-control-lg fw-bold" placeholder="0" min="1" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Motif / Raison</label>
                                <input type="text" name="raison" class="form-control" placeholder="Ex: Cadeau, Loyer...">
                            </div>
                            <div class="form-check form-switch mb-4">
                                <input class="form-check-input" type="checkbox" name="payerFraisRetrait" id="switchFrais">
                                <label class="form-check-label small fw-bold" for="switchFrais">Inclure frais de retrait</label>
                            </div>
                            <button type="button" onclick="preparerConfirmation('envoi')" class="btn btn-dark btn-action w-100 shadow">Confirmer l'envoi</button>
                        </form>
                    </div>

                    <div class="col-lg-8">
                        <div class="d-flex justify-content-between align-items-center mb-3 px-2">
                            <span class="fw-bold small text-muted">FLUX RÉCENTS</span>
                            <input type="date" id="dateEnv" class="form-control form-control-sm w-auto" onchange="filtrer('env')">
                        </div>
                        <div class="table-responsive">
                            <table class="table table-vola align-middle">
                                <thead>
                                    <tr>
                                        <th>Date</th>
                                        <th>Expéditeur</th>
                                        <th>Bénéficiaire</th>
                                        <th>Raison</th>
                                        <th class="text-end">Montant</th>
                                        <th class="text-center">Frais Retrait</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        TransactionDAO dao = new TransactionDAO();
                                        List<Envoi> listeE = dao.listerDerniersEnvois();
                                        for(Envoi e : listeE) {
                                    %>
                                    <tr class="row-env" data-date="<%= e.getDate().toString().substring(0,10) %>">
                                        <td class="text-muted small"><%= new java.text.SimpleDateFormat("dd/MM/yy").format(e.getDate()) %></td>
                                        <td class="fw-medium"><%= e.getNumEnvoyeur() %></td>
                                        <td class="fw-medium"><%= e.getNumRecepteur() %></td>
                                        <td class="small text-muted text-truncate" style="max-width: 120px;"><%= (e.getRaison() != null && !e.getRaison().isEmpty()) ? e.getRaison() : "-" %></td>
                                        <td class="text-end price-up"><%= String.format("%,d", e.getMontant()) %></td>
                                        <td class="text-center">
                                            <% if(e.isPayer_frais_retrait()) { %>
                                                <span class="badge-frais frais-ok"><i class="bi bi-check-circle-fill me-1"></i>Payé</span>
                                            <% } else { %>
                                                <span class="badge-frais frais-ko">À charge</span>
                                            <% } %>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ===== ONGLET RETRAITS ===== -->
            <div class="tab-pane fade" id="tab-retrait">
                <div class="row g-4">
                    <div class="col-lg-4 border-end">
                        <h6 class="fw-bold mb-4 text-muted small text-uppercase">Effectuer un Retrait</h6>
                        <form action="TransactionServlet" method="POST" id="retraitForm">
                            <input type="hidden" name="action" value="retirer">
                            <div class="mb-3">
                                <label class="form-label">Numéro du Client</label>
                                <input list="listeNumeros" name="numtel" class="form-control" placeholder="Saisir numéro..." required>
                            </div>
                            <div class="mb-4">
                                <label class="form-label">Montant du retrait (Ar)</label>
                                <input type="number" name="montant" id="montantRet" class="form-control form-control-lg fw-bold" placeholder="0" min="1" required>
                            </div>
                            <button type="button" onclick="preparerConfirmation('retrait')" class="btn btn-dark btn-action w-100 shadow">Confirmer le retrait</button>
                        </form>
                    </div>

                    <div class="col-lg-8">
                        <div class="d-flex justify-content-between align-items-center mb-3 px-2">
                            <span class="fw-bold small text-muted">HISTORIQUE RETRAITS</span>
                            <input type="date" id="dateRet" class="form-control form-control-sm w-auto" onchange="filtrer('ret')">
                        </div>
                        <div class="table-responsive">
                            <table class="table table-vola align-middle">
                                <thead>
                                    <tr>
                                        <th>Date & Heure</th>
                                        <th>Numéro Client</th>
                                        <th class="text-center">Statut</th>
                                        <th class="text-end">Montant Retiré</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        List<Retrait> listeR = dao.listerDerniersRetraits();
                                        for(Retrait r : listeR) {
                                    %>
                                    <tr class="row-ret" data-date="<%= r.getDaterecep().toString().substring(0,10) %>">
                                        <td class="text-muted small"><%= new java.text.SimpleDateFormat("dd/MM/yy HH:mm").format(r.getDaterecep()) %></td>
                                        <td class="fw-medium"><%= r.getNumtel() %></td>
                                        <td class="text-center"><span class="badge-frais frais-ok"><i class="bi bi-check-circle-fill me-1"></i>Succès</span></td>
                                        <td class="text-end price-down">- <%= String.format("%,d", r.getMontant()) %></td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<!-- ===== MODAL RELEVÉ PDF ===== -->
<div class="modal fade" id="releveModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg" style="border-radius: 15px;">
            <div class="modal-header border-0 p-4 pb-2">
                <h5 class="modal-title fw-bold"><i class="bi bi-file-earmark-pdf text-danger me-2"></i>Générer un Relevé</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4">
                <form action="RelevePdfServlet" method="GET" target="_blank">
                    <div class="mb-3">
                        <label class="form-label">Numéro du client</label>
                        <select name="numtel" class="form-select" required>
                            <option value="" selected disabled>Choisir un numéro...</option>
                            <% try { ClientDAO clDao = new ClientDAO(); for(Client cl : clDao.listerClients("")) { %>
                                <option value="<%= cl.getNumtel() %>"><%= cl.getNumtel() %> — <%= cl.getNom() %></option>
                            <% } } catch(Exception e) {} %>
                        </select>
                    </div>
                    <div class="mb-4">
                        <label class="form-label">Mois du relevé</label>
                        <input type="month" name="mois" class="form-control" required>
                    </div>
                    <div class="p-3 mb-3" style="background:#F8FAFC; border-radius: 10px; font-size: 0.82rem; color: #64748B;">
                        Le document inclura toutes les transactions du client pour le mois sélectionné.
                    </div>
                    <button type="submit" class="btn btn-dark w-100 py-2 fw-bold" style="border-radius: 10px;">
                        <i class="bi bi-download me-2"></i>Télécharger le document
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- ===== MODAL CONFIRMATION ===== -->
<div class="modal fade" id="confirmModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg" style="border-radius: 20px;">
            <div id="modalHeader" class="modal-header border-0 p-4">
                <h5 class="modal-title fw-bold">Confirmation</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4 text-center">
                <div id="confirmNum" class="fw-bold fs-3 text-primary mb-3"></div>
                <div class="p-3 bg-light rounded-4">
                    <div class="d-flex justify-content-between mb-2 small text-muted"><span>Montant :</span><span id="cMontant" class="fw-bold text-dark"></span></div>
                    <div id="rowFraisEnv" class="d-flex justify-content-between mb-1 small text-danger"><span>Frais Envoi :</span><span id="cFraisE"></span></div>
                    <div id="rowFraisRet" class="d-flex justify-content-between mb-2 small text-danger"><span>Frais Retrait :</span><span id="cFraisR"></span></div>
                    <hr>
                    <div class="d-flex justify-content-between fs-5 fw-bold text-dark"><span>TOTAL :</span><span id="cTotal"></span></div>
                </div>
            </div>
            <div class="modal-footer border-0 p-4 pt-0">
                <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Annuler</button>
                <button type="button" id="btnFinal" class="btn btn-dark rounded-pill px-4">Confirmer</button>
            </div>
        </div>
    </div>
</div>

<!-- ===== TOAST NOTIFICATIONS ===== -->
<div class="toast-container position-fixed bottom-0 end-0 p-3">
    <div id="liveToast" class="toast align-items-center text-white border-0 shadow-lg" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="d-flex">
            <div class="toast-body fw-bold" id="toastMsg"></div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
        </div>
    </div>
</div>

<!-- ===== DATALIST NUMÉROS ===== -->
<datalist id="listeNumeros">
    <% try { ClientDAO clDao = new ClientDAO(); for(Client cl : clDao.listerClients("")) { %>
        <option value="<%= cl.getNumtel() %>"><%= cl.getNom() %></option>
    <% } } catch(Exception e) {} %>
</datalist>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const bModal = new bootstrap.Modal(document.getElementById('confirmModal'));
    const toastBootstrap = bootstrap.Toast.getOrCreateInstance(document.getElementById('liveToast'));

    function showNotify(message, type) {
        const toastEl = document.getElementById('liveToast');
        document.getElementById('toastMsg').innerText = message;
        toastEl.className = 'toast align-items-center text-white border-0 shadow-lg bg-' + (type === 'success' ? 'success' : 'danger');
        toastBootstrap.show();
    }

    function preparerConfirmation(type) {
        let num, montant, retraitParam, actionForm;
        if (type === 'envoi') {
            num = document.querySelector('#tab-transfert input[name="numRecepteur"]').value;
            montant = document.getElementById('montantE').value;
            retraitParam = document.getElementById('switchFrais').checked;
            actionForm = 'envoiForm';
            document.getElementById('modalHeader').style.backgroundColor = 'var(--accent-mint)';
            document.getElementById('modalHeader').classList.remove('text-white');
        } else {
            num = document.querySelector('#tab-retrait input[name="numtel"]').value;
            montant = document.getElementById('montantRet').value;
            retraitParam = true;
            actionForm = 'retraitForm';
            document.getElementById('modalHeader').style.backgroundColor = '#0F172A';
            document.getElementById('modalHeader').classList.add('text-white');
        }

        if (!num || montant < 1) {
            showNotify('Veuillez saisir un numéro et un montant valide (min 1 Ar).', 'error');
            return;
        }

        fetch('CalculFraisServlet?montant=' + montant + '&retrait=' + retraitParam)
            .then(r => r.text())
            .then(data => {
                const f = data.split(',');
                const fE = (type === 'envoi') ? parseInt(f[0]) : 0;
                const fR = parseInt(f[1]);
                const total = parseInt(montant) + fE + fR;

                document.getElementById('confirmNum').innerText = num;
                document.getElementById('cMontant').innerText = parseInt(montant).toLocaleString() + ' Ar';
                document.getElementById('rowFraisEnv').style.display = (type === 'envoi') ? 'flex' : 'none';
                document.getElementById('cFraisE').innerText = '+ ' + fE.toLocaleString() + ' Ar';
                document.getElementById('cFraisR').innerText = '+ ' + fR.toLocaleString() + ' Ar';
                document.getElementById('cTotal').innerText = total.toLocaleString() + ' Ar';

                document.getElementById('btnFinal').onclick = () => document.getElementById(actionForm).submit();
                bModal.show();
            })
            .catch(() => showNotify('Erreur lors du calcul des frais.', 'error'));
    }

    function filtrer(type) {
        const d = (type === 'env') ? document.getElementById('dateEnv').value : document.getElementById('dateRet').value;
        const rows = (type === 'env') ? document.querySelectorAll('.row-env') : document.querySelectorAll('.row-ret');
        rows.forEach(r => r.style.display = (!d || r.dataset.date === d) ? '' : 'none');
    }

    window.onload = () => {
        const params = new URLSearchParams(window.location.search);
        if (params.get('msg') === 'success')      showNotify('Opération validée avec succès !', 'success');
        if (params.get('msg') === 'error_solde')  showNotify('Solde insuffisant pour cette opération.', 'error');
        if (params.get('msg') === 'error')        showNotify('Une erreur technique est survenue.', 'error');
        window.history.replaceState({}, '', window.location.pathname);
    };
</script>
</body>
</html>
