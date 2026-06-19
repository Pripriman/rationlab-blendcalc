import 'package:flutter/material.dart';
import '../../theme/lab_palette.dart';
import '../../theme/lab_type.dart';
import '../../widgets/solve_button.dart';

class _Slide {
  final IconData icon;
  final String title;
  final String body;
  const _Slide(this.icon, this.title, this.body);
}

class IntroReel extends StatefulWidget {
  final VoidCallback onDone;
  const IntroReel({super.key, required this.onDone});

  @override
  State<IntroReel> createState() => _IntroReelState();
}

class _IntroReelState extends State<IntroReel> {
  final _controller = PageController();
  int _index = 0;

  static const _slides = [
    _Slide(Icons.science_outlined, 'Balance the ration',
        'Pick the flock, set the goal and let the calculator balance protein, energy and amino acids against the published targets.'),
    _Slide(Icons.swap_horiz_rounded, 'Swap to cheaper feed',
        'See where soybean, maize or sunflower can be part-replaced without dropping below spec, and watch the cost per kilogram fall.'),
    _Slide(Icons.calculate_rounded, 'Cost every egg',
        'Translate the blend into a real cost per egg using daily intake and lay rate, so optimisation turns into measurable margin.'),
    _Slide(Icons.auto_awesome_rounded, 'Least-cost solver',
        'Let the mix solver search ingredient combinations for the cheapest formula that still meets every nutrient minimum.'),
  ];

  bool get _last => _index == _slides.length - 1;

  void _next() {
    if (_last) {
      widget.onDone();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LabPalette.sheetGradient),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8, top: 4),
                  child: AnimatedOpacity(
                    opacity: _last ? 0 : 1,
                    duration: const Duration(milliseconds: 200),
                    child: TextLink(
                      label: 'Skip',
                      onPressed: _last ? null : widget.onDone,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _slides.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (context, i) {
                    final s = _slides[i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              color: LabPalette.limeWash,
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: Icon(s.icon,
                                size: 60, color: LabPalette.limeDeep),
                          ),
                          const SizedBox(height: 40),
                          Text(s.title,
                              style: LabType.title(),
                              textAlign: TextAlign.center),
                          const SizedBox(height: 14),
                          Text(s.body,
                              style: LabType.body(),
                              textAlign: TextAlign.center),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_slides.length, (i) {
                  final active = i == _index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 240),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: active ? 22 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: active ? LabPalette.limeDeep : LabPalette.rule,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 24, 32, 28),
                child: SolveButton(
                  label: _last ? 'Open the calculator' : 'Next',
                  onPressed: _next,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
