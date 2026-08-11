// import flutter material
import 'package:flutter/material.dart';

// import provider
import 'package:provider/provider.dart';

// import reseller provider
import '../viewmodels/reseller_provider.dart';

// import theme
import '../../../core/theme/auth_theme.dart';

// import reseller user page
import 'reseller_user_page.dart';

// import edit reseller
import 'edit_reseller_page.dart';

// ============================================================
// HALAMAN DETAIL RESELLER
// ============================================================

class ResellerDetailPage extends StatefulWidget {
  final dynamic reseller;

  const ResellerDetailPage({super.key, required this.reseller});

  @override
  State<ResellerDetailPage> createState() => _ResellerDetailPageState();
}

class _ResellerDetailPageState extends State<ResellerDetailPage> {
  late Map<String, dynamic> reseller;

  bool _isProcessing = false;

  // ==========================================================
  // INIT
  // ==========================================================

  @override
  void initState() {
    super.initState();

    reseller = Map<String, dynamic>.from(widget.reseller);
  }

  // ==========================================================
  // SHOW MESSAGE
  // ==========================================================

  void _showMessage(String message, {Color backgroundColor = Colors.black87}) {
    if (!mounted) return;

    final messenger = ScaffoldMessenger.maybeOf(context);

    if (messenger == null) return;

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), backgroundColor: backgroundColor),
      );
  }

  // ==========================================================
  // DIALOG SUSPEND
  // ==========================================================

  Future<String?> _showSuspendReasonDialog() async {
    if (!mounted) return null;

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return _SuspendResellerDialog(reseller: reseller);
      },
    );
  }

  // ==========================================================
  // DIALOG AKTIFKAN DARI SUSPEND
  // ==========================================================

  Future<bool?> _showActivateDialog() async {
    if (!mounted) return null;

    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return _ActivateResellerDialog(reseller: reseller);
      },
    );
  }

  // ==========================================================
  // DIALOG NONAKTIF
  // ==========================================================

  Future<bool?> _showDeactivateDialog() async {
    if (!mounted) return null;

    final name = reseller['name']?.toString() ?? '-';

    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AuthTheme.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          contentPadding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
          actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 18),

          // ==================================================
          // TITLE
          // ==================================================
          title: Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.person_off, color: Colors.red),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Text(
                  'Nonaktifkan Reseller',
                  style: TextStyle(
                    color: AuthTheme.title,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          // ==================================================
          // CONTENT
          // ==================================================
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Anda akan menonaktifkan reseller:',
                style: TextStyle(color: AuthTheme.subtitle, fontSize: 13),
              ),

              const SizedBox(height: 10),

              Text(
                name,
                style: const TextStyle(
                  color: AuthTheme.title,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 18),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.red,
                      size: 20,
                    ),

                    SizedBox(width: 8),

                    Expanded(
                      child: Text(
                        'Reseller tidak dapat menggunakan akun selama status nonaktif.',
                        style: TextStyle(
                          color: AuthTheme.subtitle,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ==================================================
          // ACTIONS
          // ==================================================
          actions: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop(false);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AuthTheme.subtitle,
                      side: BorderSide(color: AuthTheme.border),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Batal'),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop(true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Nonaktifkan',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // ==========================================================
  // DIALOG AKTIFKAN DARI NONAKTIF
  // ==========================================================

  Future<bool?> _showActivateInactiveDialog() async {
    if (!mounted) return null;

    final name = reseller['name']?.toString() ?? '-';

    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AuthTheme.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          contentPadding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
          actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 18),

          // ==================================================
          // TITLE
          // ==================================================
          title: Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.person, color: Colors.green),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Text(
                  'Aktifkan Reseller',
                  style: TextStyle(
                    color: AuthTheme.title,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          // ==================================================
          // CONTENT
          // ==================================================
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Anda akan mengaktifkan kembali reseller:',
                style: TextStyle(color: AuthTheme.subtitle, fontSize: 13),
              ),

              const SizedBox(height: 10),

              Text(
                name,
                style: const TextStyle(
                  color: AuthTheme.title,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 18),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.green.withValues(alpha: 0.2),
                  ),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                      size: 20,
                    ),

                    SizedBox(width: 8),

                    Expanded(
                      child: Text(
                        'Reseller dapat kembali menggunakan akun setelah diaktifkan.',
                        style: TextStyle(
                          color: AuthTheme.subtitle,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ==================================================
          // ACTIONS
          // ==================================================
          actions: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop(false);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AuthTheme.subtitle,
                      side: BorderSide(color: AuthTheme.border),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Batal'),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop(true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Aktifkan',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // ==========================================================
  // PROSES SUSPEND
  // ==========================================================

  Future<void> _handleSuspend() async {
    if (_isProcessing) return;

    final resellerId = reseller['_id']?.toString();

    if (resellerId == null || resellerId.isEmpty) {
      _showMessage('ID reseller tidak ditemukan', backgroundColor: Colors.red);
      return;
    }

    final provider = context.read<ResellerProvider>();

    final reason = await _showSuspendReasonDialog();

    if (!mounted) return;

    if (reason == null || reason.trim().isEmpty) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final result = await provider.suspendReseller(
        resellerId: resellerId,
        reason: reason.trim(),
      );

      if (!mounted) return;

      if (!result) {
        _showMessage('Gagal men-suspend reseller', backgroundColor: Colors.red);
        return;
      }

      setState(() {
        reseller['accountStatus'] = 'suspended';
        reseller['suspendReason'] = reason.trim();
        reseller['isActive'] = false;
      });

      _showMessage(
        'Reseller berhasil disuspend',
        backgroundColor: Colors.orange,
      );
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'Terjadi kesalahan saat suspend reseller',
        backgroundColor: Colors.red,
      );

      debugPrint('ERROR SUSPEND RESELLER: $e');
    } finally {
      if (!mounted) return;

      setState(() {
        _isProcessing = false;
      });
    }
  }

  // ==========================================================
  // PROSES AKTIFKAN DARI SUSPEND
  // ==========================================================

  Future<void> _handleActivate() async {
    if (_isProcessing) return;

    final resellerId = reseller['_id']?.toString();

    if (resellerId == null || resellerId.isEmpty) {
      _showMessage('ID reseller tidak ditemukan', backgroundColor: Colors.red);
      return;
    }

    final provider = context.read<ResellerProvider>();

    final confirm = await _showActivateDialog();

    if (!mounted) return;

    if (confirm != true) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final result = await provider.activateReseller(resellerId);

      if (!mounted) return;

      if (!result) {
        _showMessage(
          'Gagal mengaktifkan reseller',
          backgroundColor: Colors.red,
        );
        return;
      }

      setState(() {
        reseller['accountStatus'] = null;
        reseller['suspendReason'] = null;
        reseller['isActive'] = true;
      });

      _showMessage(
        'Reseller berhasil diaktifkan',
        backgroundColor: Colors.green,
      );
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'Terjadi kesalahan saat mengaktifkan reseller',
        backgroundColor: Colors.red,
      );

      debugPrint('ERROR ACTIVATE RESELLER: $e');
    } finally {
      if (!mounted) return;

      setState(() {
        _isProcessing = false;
      });
    }
  }

  // ==========================================================
  // PROSES AKTIF / NONAKTIF
  // ==========================================================

  Future<void> _handleActiveStatus() async {
    if (_isProcessing) return;

    final resellerId = reseller['_id']?.toString();

    if (resellerId == null || resellerId.isEmpty) {
      _showMessage('ID reseller tidak ditemukan', backgroundColor: Colors.red);
      return;
    }

    final provider = context.read<ResellerProvider>();

    final isActive = reseller['isActive'] == true;

    // ========================================================
    // TAMPILKAN DIALOG TERLEBIH DAHULU
    // ========================================================

    final bool? confirm = isActive
        ? await _showDeactivateDialog()
        : await _showActivateInactiveDialog();

    if (!mounted) return;

    if (confirm != true) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      bool result;

      if (isActive) {
        result = await provider.deactivateReseller(resellerId);
      } else {
        result = await provider.activateReseller(resellerId);
      }

      if (!mounted) return;

      if (!result) {
        _showMessage(
          'Gagal memperbarui status reseller',
          backgroundColor: Colors.red,
        );
        return;
      }

      setState(() {
        reseller['isActive'] = !isActive;
      });

      _showMessage(
        isActive
            ? 'Reseller berhasil dinonaktifkan'
            : 'Reseller berhasil diaktifkan',
        backgroundColor: Colors.green,
      );
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'Terjadi kesalahan saat memperbarui status',
        backgroundColor: Colors.red,
      );

      debugPrint('ERROR ACTIVE STATUS RESELLER: $e');
    } finally {
      if (!mounted) return;

      setState(() {
        _isProcessing = false;
      });
    }
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final bool isSuspended =
        reseller['accountStatus']?.toString() == 'suspended';

    final bool isActive = reseller['isActive'] == true;

    final String resellerId = reseller['_id']?.toString() ?? '';

    return Scaffold(
      backgroundColor: AuthTheme.background,

      // ======================================================
      // APP BAR
      // ======================================================
      appBar: AppBar(
        backgroundColor: AuthTheme.background,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: _isProcessing
              ? null
              : () {
                  Navigator.pop(context);
                },
        ),

        title: Row(
          children: [
            Image.asset('assets/logos/TBS.png', height: 30),

            const SizedBox(width: 10),

            const Text(
              'Detail Reseller',
              style: TextStyle(
                color: AuthTheme.title,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      // ======================================================
      // BODY
      // ======================================================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Container(
          padding: const EdgeInsets.all(20),

          decoration: BoxDecoration(
            color: AuthTheme.cardBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AuthTheme.border),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // ==================================================
              // PROFILE
              // ==================================================
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,

                    decoration: BoxDecoration(
                      gradient: AuthTheme.buttonGradient,
                      shape: BoxShape.circle,
                    ),

                    child: Center(
                      child: Text(
                        reseller['name'] != null &&
                                reseller['name'].toString().isNotEmpty
                            ? reseller['name'].toString()[0].toUpperCase()
                            : 'R',

                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          reseller['name']?.toString() ?? '-',

                          style: const TextStyle(
                            color: AuthTheme.title,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          reseller['email']?.toString() ?? '-',
                          overflow: TextOverflow.ellipsis,

                          style: const TextStyle(color: AuthTheme.subtitle),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 5),

              // ==================================================
              // PEMILIK
              // ==================================================
              Text(
                'Pemilik : '
                '${reseller["ownerId"] is Map ? reseller["ownerId"]["name"] : "-"}',

                style: const TextStyle(color: AuthTheme.subtitle),
              ),

              const SizedBox(height: 25),

              // ==================================================
              // PHONE
              // ==================================================
              Text(
                'Phone : '
                '${reseller["phone"] ?? "-"}',

                style: const TextStyle(color: AuthTheme.title),
              ),

              const SizedBox(height: 10),

              // ==================================================
              // COIN
              // ==================================================
              Row(
                children: [
                  const Icon(
                    Icons.monetization_on,
                    color: Colors.amber,
                    size: 19,
                  ),

                  const SizedBox(width: 7),

                  Text(
                    'Coin : '
                    '${reseller["coinBalance"] ?? 0}',

                    style: const TextStyle(
                      color: AuthTheme.title,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ==================================================
              // STATUS
              // ==================================================
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 10,

                    color: isSuspended
                        ? Colors.orange
                        : isActive
                        ? Colors.green
                        : Colors.red,
                  ),

                  const SizedBox(width: 8),

                  Text(
                    isSuspended
                        ? 'Suspend'
                        : isActive
                        ? 'Aktif'
                        : 'Tidak Aktif',

                    style: TextStyle(
                      color: isSuspended
                          ? Colors.orange
                          : isActive
                          ? Colors.green
                          : Colors.red,

                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              // ==================================================
              // ALASAN SUSPEND
              // ==================================================
              if (isSuspended)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const SizedBox(height: 15),

                    const Text(
                      'Alasan Suspend :',

                      style: TextStyle(
                        color: AuthTheme.title,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      reseller['suspendReason']?.toString() ?? '-',

                      style: const TextStyle(color: AuthTheme.subtitle),
                    ),
                  ],
                ),

              const SizedBox(height: 30),

              // ==================================================
              // BUTTON GRID
              // ==================================================
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3,

                children: [
                  // =================================================
                  // LIHAT USER
                  // =================================================
                  Container(
                    decoration: BoxDecoration(
                      gradient: AuthTheme.buttonGradient,

                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),

                      onPressed: _isProcessing || resellerId.isEmpty
                          ? null
                          : () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ResellerUserPage(resellerId: resellerId),
                                ),
                              );
                            },

                      icon: const Icon(Icons.people, color: Colors.white),

                      label: const Text(
                        'Lihat User',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                  // =================================================
                  // EDIT
                  // =================================================
                  Container(
                    decoration: BoxDecoration(
                      gradient: AuthTheme.buttonGradient,

                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),

                      onPressed: _isProcessing || resellerId.isEmpty
                          ? null
                          : () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      EditResellerPage(reseller: reseller),
                                ),
                              );

                              if (!mounted) {
                                return;
                              }

                              if (result == true) {
                                Navigator.pop(context, true);
                              }
                            },

                      icon: const Icon(Icons.edit, color: Colors.white),

                      label: const Text(
                        'Edit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                  // =================================================
                  // SUSPEND / AKTIFKAN
                  // =================================================
                  Container(
                    decoration: BoxDecoration(
                      gradient: AuthTheme.buttonGradient,

                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),

                      onPressed: _isProcessing || resellerId.isEmpty
                          ? null
                          : isSuspended
                          ? _handleActivate
                          : _handleSuspend,

                      icon: _isProcessing
                          ? const SizedBox(
                              width: 18,
                              height: 18,

                              child: CircularProgressIndicator(
                                strokeWidth: 2,

                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Icon(
                              isSuspended ? Icons.check_circle : Icons.block,

                              color: Colors.white,
                            ),

                      label: Text(
                        _isProcessing
                            ? 'Memproses...'
                            : isSuspended
                            ? 'Aktifkan'
                            : 'Suspend',

                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                  // =================================================
                  // NONAKTIF / AKTIFKAN
                  // =================================================
                  Container(
                    decoration: BoxDecoration(
                      color: isSuspended
                          ? Colors.grey
                          : isActive
                          ? Colors.red
                          : Colors.green,

                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),

                      onPressed:
                          _isProcessing || isSuspended || resellerId.isEmpty
                          ? null
                          : _handleActiveStatus,

                      icon: Icon(
                        isActive ? Icons.person_off : Icons.person,

                        color: Colors.white,
                      ),

                      label: Text(
                        isSuspended
                            ? 'Disuspend'
                            : isActive
                            ? 'Nonaktif'
                            : 'Aktifkan',

                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// DIALOG SUSPEND RESELLER
// ============================================================

class _SuspendResellerDialog extends StatefulWidget {
  final Map<String, dynamic> reseller;

  const _SuspendResellerDialog({required this.reseller});

  @override
  State<_SuspendResellerDialog> createState() => _SuspendResellerDialogState();
}

class _SuspendResellerDialogState extends State<_SuspendResellerDialog> {
  late final TextEditingController _controller;

  bool _submitting = false;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  void _submit() {
    if (_submitting) return;

    final reason = _controller.text.trim();

    if (reason.isEmpty) {
      return;
    }

    setState(() {
      _submitting = true;
    });

    FocusManager.instance.primaryFocus?.unfocus();

    Navigator.of(context).pop(reason);
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.reseller['name']?.toString() ?? '-';

    final email = widget.reseller['email']?.toString() ?? '-';

    return AlertDialog(
      backgroundColor: AuthTheme.cardBackground,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),

      contentPadding: const EdgeInsets.fromLTRB(20, 18, 20, 10),

      actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 18),

      title: Row(
        children: [
          Container(
            width: 45,
            height: 45,

            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.15),

              borderRadius: BorderRadius.circular(12),
            ),

            child: const Icon(Icons.block, color: Colors.orange),
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Text(
              'Suspend Reseller',
              style: TextStyle(
                color: AuthTheme.title,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),

      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              'Anda akan men-suspend reseller:',
              style: TextStyle(color: AuthTheme.subtitle, fontSize: 13),
            ),

            const SizedBox(height: 8),

            Text(
              name,
              style: const TextStyle(
                color: AuthTheme.title,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              email,
              style: const TextStyle(color: AuthTheme.subtitle, fontSize: 12),
            ),

            const SizedBox(height: 18),

            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(12),

              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.08),

                borderRadius: BorderRadius.circular(12),

                border: Border.all(color: Colors.orange.withValues(alpha: 0.2)),
              ),

              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange,
                    size: 20,
                  ),

                  SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      'Reseller tidak dapat menggunakan akun sampai suspend dicabut.',
                      style: TextStyle(color: AuthTheme.subtitle, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'Alasan Suspend',
              style: TextStyle(
                color: AuthTheme.title,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: _controller,
              maxLines: 4,
              enabled: !_submitting,

              style: const TextStyle(color: AuthTheme.title, fontSize: 13),

              decoration: InputDecoration(
                hintText: 'Contoh: Pelanggaran aturan penggunaan...',

                hintStyle: const TextStyle(color: AuthTheme.hint, fontSize: 12),

                filled: true,

                fillColor: AuthTheme.inputFill,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),

                  borderSide: BorderSide(color: AuthTheme.border),
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),

                  borderSide: BorderSide(color: AuthTheme.border),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),

                  borderSide: const BorderSide(color: Colors.orange),
                ),

                contentPadding: const EdgeInsets.all(14),
              ),
            ),
          ],
        ),
      ),

      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _submitting
                    ? null
                    : () {
                        FocusManager.instance.primaryFocus?.unfocus();

                        Navigator.of(context).pop(null);
                      },

                style: OutlinedButton.styleFrom(
                  foregroundColor: AuthTheme.subtitle,

                  side: BorderSide(color: AuthTheme.border),

                  padding: const EdgeInsets.symmetric(vertical: 13),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                child: const Text('Batal'),
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: ElevatedButton(
                onPressed: _submitting ? null : _submit,

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,

                  foregroundColor: Colors.white,

                  padding: const EdgeInsets.symmetric(vertical: 13),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                child: _submitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,

                        child: CircularProgressIndicator(
                          strokeWidth: 2,

                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text(
                        'Suspend',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ============================================================
// DIALOG AKTIFKAN DARI SUSPEND
// ============================================================

class _ActivateResellerDialog extends StatelessWidget {
  final Map<String, dynamic> reseller;

  const _ActivateResellerDialog({required this.reseller});

  @override
  Widget build(BuildContext context) {
    final name = reseller['name']?.toString() ?? '-';

    return AlertDialog(
      backgroundColor: AuthTheme.cardBackground,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),

      contentPadding: const EdgeInsets.fromLTRB(20, 18, 20, 10),

      actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 18),

      title: Row(
        children: [
          Container(
            width: 45,
            height: 45,

            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.15),

              borderRadius: BorderRadius.circular(12),
            ),

            child: const Icon(Icons.check_circle, color: Colors.green),
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Text(
              'Aktifkan Reseller',
              style: TextStyle(
                color: AuthTheme.title,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),

      content: Column(
        mainAxisSize: MainAxisSize.min,

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            'Anda akan mengaktifkan kembali reseller:',
            style: TextStyle(color: AuthTheme.subtitle, fontSize: 13),
          ),

          const SizedBox(height: 10),

          Text(
            name,
            style: const TextStyle(
              color: AuthTheme.title,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 18),

          Container(
            width: double.infinity,

            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.08),

              borderRadius: BorderRadius.circular(12),

              border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
            ),

            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Icon(Icons.check_circle_outline, color: Colors.green, size: 20),

                SizedBox(width: 8),

                Expanded(
                  child: Text(
                    'Suspend akan dicabut dan reseller dapat kembali menggunakan akunnya.',
                    style: TextStyle(color: AuthTheme.subtitle, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },

                style: OutlinedButton.styleFrom(
                  foregroundColor: AuthTheme.subtitle,

                  side: BorderSide(color: AuthTheme.border),

                  padding: const EdgeInsets.symmetric(vertical: 13),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                child: const Text('Batal'),
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,

                  foregroundColor: Colors.white,

                  padding: const EdgeInsets.symmetric(vertical: 13),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                child: const Text(
                  'Aktifkan',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
