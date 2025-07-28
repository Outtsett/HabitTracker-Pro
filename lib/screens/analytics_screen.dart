import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../services/progress_tracking_service.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [Colors.grey[900]!, Colors.grey[800]!]
              : [const Color(0xFF1A1A1A), const Color(0xFF2D2D2D)],
        ),
      ),
      child: Consumer<HabitProvider>(
        builder: (context, habitProvider, child) {
          final habits = habitProvider.habits;
          
          if (habits.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.analytics_outlined,
                    size: 80,
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No Analytics Yet',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add some habits to see your lazy analytics',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          final metrics = ProgressTrackingService.calculateProgressMetrics(habits);
          final insights = ProgressTrackingService.generateLazyInsights(habits);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Lazy Analytics',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Key metrics cards
                _buildMetricsGrid(metrics, insights),
                const SizedBox(height: 24),
                
                // Weekly trend
                _buildWeeklyTrend(metrics),
                const SizedBox(height: 24),
                
                // Insights section
                _buildInsightsSection(insights),
                const SizedBox(height: 24),
                
                // Achievements
                _buildAchievementsSection(metrics),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetricsGrid(Map<String, dynamic> metrics, Map<String, dynamic> insights) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _buildMetricCard(
          'Progress',
          '${insights['progressPercent']}%',
          Icons.trending_up,
          Colors.purple,
        ),
        _buildMetricCard(
          'Laziness Score',
          '${(insights['lazynessScore'] as double).round()}',
          Icons.psychology,
          Colors.blue,
        ),
        _buildMetricCard(
          'Total Habits',
          '${metrics['activeHabits']}',
          Icons.track_changes,
          Colors.green,
        ),
        _buildMetricCard(
          'Avg Streak',
          '${(metrics['averageStreak'] as double).round()} days',
          Icons.local_fire_department,
          Colors.orange,
        ),
        _buildMetricCard(
          'Completions',
          '${metrics['totalCompletions']}',
          Icons.check_circle,
          Colors.teal,
        ),
        _buildMetricCard(
          'Consistency',
          '${((metrics['consistencyScore'] as double) * 100).round()}%',
          Icons.stars,
          Colors.amber,
        ),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 32,
            color: color,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyTrend(Map<String, dynamic> metrics) {
    final weeklyTrend = metrics['weeklyTrend'] as List<Map<String, dynamic>>;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[800]?.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.purple.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.show_chart, color: Colors.purple, size: 24),
              const SizedBox(width: 8),
              const Text(
                'Weekly Progress Trend',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Simple bar chart representation
          ...weeklyTrend.map((week) {
            final completions = week['completions'] as int;
            final maxCompletions = weeklyTrend.fold<int>(0, (max, w) => 
              w['completions'] as int > max ? w['completions'] as int : max);
            final progress = maxCompletions > 0 ? completions / maxCompletions : 0.0;
            
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(
                      week['weekLabel'].toString(),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: progress,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$completions',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildInsightsSection(Map<String, dynamic> insights) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue[900]?.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.blue.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, color: Colors.blue, size: 24),
              const SizedBox(width: 8),
              const Text(
                'Lazy Insights',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Primary insight
          Text(
            insights['primaryInsight'],
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          
          // Actionable
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.arrow_forward, color: Colors.blue, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    insights['actionable'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue[300],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsSection(Map<String, dynamic> metrics) {
    final achievements = metrics['lazyAchievements'] as List<String>;
    
    if (achievements.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[800]?.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(Icons.emoji_events, color: Colors.grey[400], size: 48),
            const SizedBox(height: 12),
            Text(
              'No Achievements Yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Keep building habits to unlock achievements!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.amber[900]?.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.amber.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.emoji_events, color: Colors.amber, size: 24),
              const SizedBox(width: 8),
              const Text(
                'Achievements',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          ...achievements.map((achievement) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    achievement,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class ProgressTrackingService {
  static Map<String, dynamic> calculateProgressMetrics(List habits) {
    // Calculate base metrics
    final activeHabits = habits.length;
    final totalCompletions = habits.fold(0, (sum, habit) => 
      sum + (habit.completedDays?.length ?? 0));
    final averageStreak = activeHabits > 0
      ? habits.fold(0, (sum, habit) => sum + (habit.currentStreak ?? 0)) / activeHabits
      : 0.0;
    final consistencyScore = activeHabits > 0 
      ? habits.fold(0.0, (sum, habit) => sum + (habit.consistencyRate ?? 0.0)) / activeHabits
      : 0.0;
    
    // Generate weekly trend data
    final weeklyTrend = _generateWeeklyTrend(habits);
    
    // Generate achievements
    final lazyAchievements = _generateAchievements(habits);
    
    return {
      'activeHabits': activeHabits,
      'totalCompletions': totalCompletions,
      'averageStreak': averageStreak,
      'consistencyScore': consistencyScore,
      'weeklyTrend': weeklyTrend,
      'lazyAchievements': lazyAchievements,
    };
  }

  static Map<String, dynamic> generateLazyInsights(List habits) {
    // Calculate progress percentage
    final totalTargets = habits.fold(0, (sum, habit) => 
      sum + (habit.targetDays?.length ?? 7));
    final totalCompletions = habits.fold(0, (sum, habit) => 
      sum + (habit.completedDays?.length ?? 0));
    final progressPercent = totalTargets > 0 
      ? ((totalCompletions / totalTargets) * 100).round()
      : 0;
    
    // Calculate laziness score (inverse of consistency)
    final consistencyScore = habits.isNotEmpty
      ? habits.fold(0.0, (sum, habit) => sum + (habit.consistencyRate ?? 0.0)) / habits.length
      : 0.0;
    final lazynessScore = 100 - (consistencyScore * 100);
    
    // Generate a primary insight
    String primaryInsight = _generatePrimaryInsight(habits, progressPercent, lazynessScore);
    
    // Generate an actionable suggestion
    String actionable = _generateActionableSuggestion(habits, lazynessScore);
    
    return {
      'progressPercent': progressPercent,
      'lazynessScore': lazynessScore,
      'primaryInsight': primaryInsight,
      'actionable': actionable,
    };
  }

  static List<Map<String, dynamic>> _generateWeeklyTrend(List habits) {
    // Mock weekly trend data - in a real app this would analyze actual data
    return [
      {'weekLabel': 'Week 1', 'completions': 14},
      {'weekLabel': 'Week 2', 'completions': 21},
      {'weekLabel': 'Week 3', 'completions': 18},
      {'weekLabel': 'Week 4', 'completions': 25},
    ];
  }

  static List<String> _generateAchievements(List habits) {
    final achievements = <String>[];
    
    if (habits.isNotEmpty) {
      achievements.add('Started your first habit tracking journey');
    }
    
    if (habits.length >= 3) {
      achievements.add('Habit enthusiast: Tracking 3+ habits');
    }
    
    // More achievements could be added based on real metrics
    
    return achievements;
  }

  static String _generatePrimaryInsight(List habits, int progressPercent, double lazynessScore) {
    if (habits.isEmpty) {
      return 'Add your first habit to start tracking your progress!';
    } else if (progressPercent < 30) {
      return 'You\'re off to a slow start, but that\'s okay! Small steps lead to big changes.';
    } else if (progressPercent < 60) {
      return 'You\'re making steady progress. Keep the momentum going!';
    } else {
      return 'Impressive work! You\'re consistently building better habits.';
    }
  }

  static String _generateActionableSuggestion(List habits, double lazynessScore) {
    if (habits.isEmpty) {
      return 'Start with one simple habit you can do daily';
    } else if (lazynessScore > 70) {
      return 'Try setting a specific time of day for your habits';
    } else if (lazynessScore > 40) {
      return 'Consider adding a reminder for your most challenging habit';
    } else {
      return 'Share your progress with a friend for extra accountability';
    }
  }
}
