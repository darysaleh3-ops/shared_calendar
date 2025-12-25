import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'groups_controller.dart';
import '../../auth/presentation/auth_controller.dart';

class GroupListScreen extends ConsumerWidget {
  const GroupListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsAsync = ref.watch(groupsControllerProvider);

    // Listen for errors (e.g. duplicate group name)
    ref.listen(groupsControllerProvider, (previous, next) {
      if (next.hasError && !next.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${next.error}')),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Groups'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authControllerProvider.notifier).logout(),
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFF202124), // Dark Background
        child: groupsAsync.when(
          data: (groups) {
            if (groups.isEmpty) {
              return const Center(
                  child: Text('No calendars yet.',
                      style: TextStyle(color: Colors.white70)));
            }
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                ExpansionTile(
                  title: const Text('My Calendars',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                  initiallyExpanded: true,
                  iconColor: Colors.white70,
                  collapsedIconColor: Colors.white70,
                  children: groups.map((group) {
                    return ListTile(
                      dense: true,
                      leading: Checkbox(
                        value: true,
                        onChanged: (v) {}, // Mock toggle
                        fillColor:
                            MaterialStateProperty.all(const Color(0xFF8AB4F8)),
                        checkColor: Colors.black,
                      ),
                      title: Text(group.name,
                          style: const TextStyle(color: Colors.white)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                      // Make the whole tile clickable to navigate
                      onTap: () => context.push('/groups/${group.id}/calendar'),
                      trailing: IconButton(
                        icon: const Icon(Icons.settings,
                            size: 16, color: Colors.white30),
                        onPressed: () {}, // Settings placeholder
                      ),
                    );
                  }).toList(),
                ),
                // Placeholder for "Other Calendars" section if needed
                const ExpansionTile(
                  title: Text('Other Calendars',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                  initiallyExpanded: true,
                  iconColor: Colors.white70,
                  collapsedIconColor: Colors.white70,
                  children: [
                    ListTile(
                      dense: true,
                      leading: Icon(Icons.check_box_outline_blank,
                          color: Colors.white38),
                      title: Text('Holidays (Mock)',
                          style: TextStyle(color: Colors.white70)),
                    )
                  ],
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error loading calendars')),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateGroupDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateGroupDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Group'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Group Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                try {
                  await ref
                      .read(groupsControllerProvider.notifier)
                      .createGroup(controller.text);
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
