import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import '../providers/app_provider.dart';

const _kDefaultOtp = '3456';

bool _isValidEmail(String email) =>
    RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email);

int _passwordStrength(String pwd) {
  if (pwd.length < 6) return 0;
  if (pwd.length < 8) return 1;
  final hasUpper = pwd.contains(RegExp(r'[A-Z]'));
  final hasDigit = pwd.contains(RegExp(r'[0-9]'));
  final hasSpecial = pwd.contains(RegExp(r'[!@#\$%^&*]'));
  return (hasUpper && hasDigit && hasSpecial) ? 3 : (hasUpper || hasDigit) ? 2 : 1;
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();
  String _countryCode = '+91';
  bool _otpSent = false;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _otpCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    final phone = _phoneCtrl.text.trim();
    if (phone.isEmpty) {
      _snack('Please enter your phone number');
      return;
    }
    if (!RegExp(r'^\d+$').hasMatch(phone) ||
        (_countryCode == '+91' && phone.length != 10)) {
      _snack('Enter the correct number');
      return;
    }
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppAdaptive.cardBg(context),
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: AppColors.primary, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'An OTP has been sent to the phone number you entered',
                style: TextStyle(color: AppAdaptive.isDark(context) ? Colors.white : Colors.black87),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    setState(() => _otpSent = true);
  }

  Future<void> _verifyOtp() async {
    final otp = _otpCtrl.text.trim();
    if (otp.isEmpty) {
      _snack('Please enter the OTP');
      return;
    }
    if (otp.length != 4) {
      _snack('OTP must be 4 digits');
      return;
    }
    if (otp != _kDefaultOtp) {
      _snack('Invalid OTP. Please try again.');
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    if (!mounted) return;
    await Provider.of<AppProvider>(context, listen: false)
        .loginWithCredentials('$_countryCode${_phoneCtrl.text.trim()}');
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/home');
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _showCountryCodePicker() {
    const codes = [
      ('+91', 'India'),
      ('+1', 'USA / Canada'),
      ('+44', 'UK'),
      ('+61', 'Australia'),
      ('+971', 'UAE'),
      ('+65', 'Singapore'),
      ('+60', 'Malaysia'),
      ('+49', 'Germany'),
      ('+33', 'France'),
      ('+81', 'Japan'),
    ];
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppAdaptive.cardBg(context),
        title: Text(
          'Select Country Code',
          style: TextStyle(
            color: AppAdaptive.isDark(context) ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: codes.map((entry) {
              final code = entry.$1;
              final name = entry.$2;
              return ListTile(
                leading: Text(code, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16)),
                title: Text(name, style: TextStyle(color: AppAdaptive.isDark(context) ? Colors.white : Colors.black87)),
                trailing: _countryCode == code ? const Icon(Icons.check, color: AppColors.primary) : null,
                onTap: () {
                  setState(() => _countryCode = code);
                  Navigator.pop(ctx);
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Future<void> _showDemoLogin(String provider) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppAdaptive.cardBg(context),
        content: Row(
          children: [
            const CircularProgressIndicator(color: AppColors.primary),
            const SizedBox(width: 20),
            Text('Signing in with $provider...', style: TextStyle(color: AppAdaptive.isDark(context) ? Colors.white : Colors.black87)),
          ],
        ),
      ),
    );
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    final nav = Navigator.of(context);
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    nav.pop();
    await appProvider.loginAsDemo(provider);
    if (!mounted) return;
    nav.pushReplacementNamed('/home');
  }

  void _showCreateAccount() {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final pwdCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    void disposeAll() {
      nameCtrl.dispose();
      emailCtrl.dispose();
      pwdCtrl.dispose();
      confirmCtrl.dispose();
    }

    bool obscure = true;
    int strength = 0;
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx2, setS) => AlertDialog(
          backgroundColor: AppAdaptive.cardBg(context),
          title: Text('Create Account', style: TextStyle(color: AppAdaptive.isDark(context) ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameCtrl,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(hintText: 'Full Name', prefixIcon: Icon(Icons.person_outline)),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Name required';
                      if (v.trim().length < 2) return 'Name too short';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(hintText: 'Email address', prefixIcon: Icon(Icons.mail_outline)),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Email required';
                      if (!_isValidEmail(v.trim())) return 'Enter a valid email (e.g. you@example.com)';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: pwdCtrl,
                    obscureText: obscure,
                    onChanged: (v) => setS(() => strength = _passwordStrength(v)),
                    decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                        onPressed: () => setS(() => obscure = !obscure),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.length < 6) return 'Minimum 6 characters';
                      return null;
                    },
                  ),
                  if (pwdCtrl.text.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _PasswordStrengthBar(strength: strength),
                  ],
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: confirmCtrl,
                    obscureText: true,
                    decoration: const InputDecoration(hintText: 'Confirm password', prefixIcon: Icon(Icons.lock_outline)),
                    validator: (v) => v != pwdCtrl.text ? 'Passwords do not match' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                final name = nameCtrl.text.trim();
                final email = emailCtrl.text.trim();
                final pwd = pwdCtrl.text;
                final nav = Navigator.of(context);
                final appProvider = Provider.of<AppProvider>(context, listen: false);
                nav.pop();
                await appProvider.registerUser(name: name, email: email, password: pwd);
                nav.pushReplacementNamed('/home');
              },
              child: const Text('Create Account'),
            ),
          ],
        ),
      ),
    ).then((_) => disposeAll());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppAdaptive.isDark(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Stack(
                  children: [
                    Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primary.withAlpha(51), Colors.transparent],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: CustomPaint(painter: _PitchPainter()),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Row(
                        children: [
                          Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
                          const SizedBox(width: 8),
                          Text('TURFZONE', style: Theme.of(context).textTheme.titleMedium?.copyWith(letterSpacing: 2.0, fontWeight: FontWeight.w900)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text('WELCOME BACK', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                Text('SIGN IN', style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                const SizedBox(height: 40),
                Text('PHONE NUMBER', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppAdaptive.textSecondary(context))),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _showCountryCodePicker,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppAdaptive.outlinedBorder(context)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(_countryCode, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const Icon(Icons.arrow_drop_down, size: 20),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.phone,
                        maxLength: _countryCode == '+91' ? 10 : 15,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: const InputDecoration(
                          hintText: 'Enter phone number',
                          counterText: '',
                        ),
                      ),
                    ),
                  ],
                ),
                if (_otpSent) ...[
                  const SizedBox(height: 24),
                  Text('OTP', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppAdaptive.textSecondary(context))),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _otpCtrl,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      hintText: '••••',
                      counterText: '',
                      hintStyle: TextStyle(color: AppAdaptive.textHint(context), letterSpacing: 4),
                    ),
                  ),
                ],
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _otpSent ? _verifyOtp : _sendOtp,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_otpSent ? 'Verify & Sign In' : 'Send OTP'),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, size: 18),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(child: Divider(color: AppAdaptive.divider(context))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('or continue with', style: TextStyle(color: AppAdaptive.textHint(context), fontSize: 12)),
                    ),
                    Expanded(child: Divider(color: AppAdaptive.divider(context))),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showDemoLogin('Google'),
                        icon: const Icon(FontAwesomeIcons.google, size: 18),
                        label: const Text('Google'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isDark ? Colors.white : Colors.black87,
                          side: BorderSide(color: AppAdaptive.outlinedBorder(context)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showDemoLogin('Apple'),
                        icon: const Icon(Icons.apple, size: 20),
                        label: const Text('Apple'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isDark ? Colors.white : Colors.black87,
                          side: BorderSide(color: AppAdaptive.outlinedBorder(context)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Center(
                  child: TextButton(
                    onPressed: _showCreateAccount,
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(color: AppAdaptive.textHint(context)),
                        children: const [
                          TextSpan(text: "Create one →", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PasswordStrengthBar extends StatelessWidget {
  final int strength; // 0=weak, 1=fair, 2=good, 3=strong

  const _PasswordStrengthBar({required this.strength});

  @override
  Widget build(BuildContext context) {
    final labels = ['Weak', 'Fair', 'Good', 'Strong'];
    final colors = [Colors.red, Colors.orange, Colors.amber, Colors.green];
    final color = colors[strength.clamp(0, 3)];
    return Row(
      children: [
        ...List.generate(3, (i) => Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i < 2 ? 4 : 0),
            height: 3,
            decoration: BoxDecoration(
              color: i < strength ? color : AppAdaptive.divider(context),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        )),
        const SizedBox(width: 8),
        Text(
          labels[strength.clamp(0, 3)],
          style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _PitchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withAlpha(25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawRect(Rect.fromLTWH(20, 40, size.width - 40, size.height - 40), paint);
    canvas.drawLine(Offset(size.width / 2, 40), Offset(size.width / 2, size.height), paint);
    canvas.drawCircle(Offset(size.width / 2, (size.height + 40) / 2), 30, paint);
    canvas.drawRect(Rect.fromLTWH(20, (size.height + 40) / 2 - 40, 30, 80), paint);
    canvas.drawRect(Rect.fromLTWH(size.width - 50, (size.height + 40) / 2 - 40, 30, 80), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
