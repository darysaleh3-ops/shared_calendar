import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'groups_controller.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../../l10n/manual_localizations.dart';

class GroupListScreen extends ConsumerWidget {
  const GroupListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsAsync = ref.watch(groupsControllerProvider);

    // Listen for errors (e.g. duplicate group name)
    ref.listen(groupsControllerProvider, (previous, next) {
      if (next.hasError && !next.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('${AppLocalizations.of(context)!.error}${next.error}')),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.myGroupsTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authControllerProvider.notifier).logout(),
          ),
        ],
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: groupsAsync.when(
          data: (groups) {
            if (groups.isEmpty) {
              return Center(
                  child: Text(AppLocalizations.of(context)!.noCalendarsLabel,
                      style: TextStyle(
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color
                              ?.withOpacity(0.7))));
            }
            final textColor = Theme.of(context).textTheme.bodyMedium?.color;
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    ExpansionTile(
                      title: Text(
                          AppLocalizations.of(context)!.myCalendarsTitle,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: textColor)),
                      initiallyExpanded: true,
                      iconColor: textColor?.withOpacity(0.7),
                      collapsedIconColor: textColor?.withOpacity(0.7),
                      children: groups.map((group) {
                        return ListTile(
                          dense: true,
                          leading: Checkbox(
                            value: true,
                            onChanged: (v) {}, // Mock toggle
                            fillColor: WidgetStateProperty.all(
                                const Color(0xFF8AB4F8)),
                            checkColor: Colors.black,
                          ),
                          title: Text(group.name,
                              style: TextStyle(color: textColor)),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 0),
                          // Make the whole tile clickable to navigate
                          onTap: () =>
                              context.push('/groups/${group.id}/calendar'),
                          trailing: IconButton(
                            icon: Icon(Icons.settings,
                                size: 16, color: textColor?.withOpacity(0.3)),
                            onPressed: () {}, // Settings placeholder
                          ),
                        );
                      }).toList(),
                    ),
                    // Placeholder for "Other Calendars" section if needed
                    ExpansionTile(
                      title: Text(
                          AppLocalizations.of(context)!.otherCalendarsTitle,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: textColor)),
                      initiallyExpanded: true,
                      iconColor: textColor?.withOpacity(0.7),
                      collapsedIconColor: textColor?.withOpacity(0.7),
                      children: [
                        ListTile(
                          dense: true,
                          leading: Icon(Icons.check_box_outline_blank,
                              color: textColor?.withOpacity(0.38)),
                          title: Text(
                              AppLocalizations.of(context)!.holidaysLabel,
                              style: TextStyle(
                                  color: textColor?.withOpacity(0.7))),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(
              child: Text(AppLocalizations.of(context)!.errorLoadingCalendars)),
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
        title: Text(AppLocalizations.of(context)!.createGroupTitle),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.groupNameLabel),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancelButton),
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
                      SnackBar(
                          content:
                              Text('${AppLocalizations.of(context)!.error}$e')),
                    );
                  }
                }
              }
            },
            child: Text(AppLocalizations.of(context)!.createButton),
          ),
        ],
      ),
    );
  }
}
