import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../groups/presentation/groups_controller.dart';
import 'events_controller.dart';
import '../domain/event.dart';
import '../../auth/domain/auth_user.dart';
import '../../../l10n/manual_localizations.dart';
import '../../auth/presentation/auth_controller.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  final String groupId;
  const CalendarScreen({required this.groupId, super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(eventsControllerProvider(widget.groupId));
    final groupAsync = ref.watch(groupDetailsProvider(widget.groupId));
    final currentUser = ref.watch(authControllerProvider).value;

    final isOwner = groupAsync.value?.ownerId == currentUser?.id;

    return Scaffold(
      appBar: AppBar(
        title: groupAsync.when(
          data: (group) => Text(group?.name ?? 'Calendar'),
          loading: () => Text(AppLocalizations.of(context)!.loading),
          error: (_, __) => Text(AppLocalizations.of(context)!.calendarTitle),
        ),
        actions: [
          // View Members (Everyone)
          IconButton(
            icon: const Icon(Icons.group),
            tooltip: 'View Members',
            onPressed: () => _showGroupMembersDialog(context),
          ),

          // Add Member (Owner only)
          if (isOwner)
            IconButton(
              icon: const Icon(Icons.person_add),
              tooltip: 'Add Member',
              onPressed: () => _showAddMemberDialog(context),
            ),

          // Delete Group (Owner only)
          if (isOwner)
            IconButton(
              icon: const Icon(Icons.delete_forever),
              tooltip: 'Delete Group',
              onPressed: () => _confirmDeleteGroup(context),
            ),

          // Add Event (Everyone - usually)
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Event',
            onPressed: () => _showAddEventDialog(context),
          ),
        ],
      ),
      body: eventsAsync.when(
        data: (events) {
          final eventsMap = _groupEventsByDay(events);
          final selectedEvents = _selectedDay == null
              ? <CalendarEvent>[]
              : eventsMap[_normalizeDate(_selectedDay!)] ?? <CalendarEvent>[];

          return LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 800;

              if (isWide) {
                // Desktop / Web Layout
                return Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: SingleChildScrollView(
                        child: _buildCalendar(eventsMap),
                      ),
                    ),
                    const VerticalDivider(width: 1, color: Color(0xFF5F6368)),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              _selectedDay != null
                                  ? '${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}'
                                  : AppLocalizations.of(context)!
                                      .noDateSelected,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ),
                          Expanded(child: _buildEventList(selectedEvents)),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                // Mobile Layout
                return Column(
                  children: [
                    _buildCalendar(eventsMap),
                    const SizedBox(height: 8.0),
                    Expanded(child: _buildEventList(selectedEvents)),
                  ],
                );
              }
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) =>
            Center(child: Text('${AppLocalizations.of(context)!.error}$err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEventDialog(context),
        icon: const Icon(Icons.add),
        label: Text(AppLocalizations.of(context)!.addEventTitle),
        backgroundColor: const Color(0xFF8AB4F8),
      ),
    );
  }

  // Vibrant Dribbble-style Colors
  final List<Color> _eventColors = const [
    Color(0xFF818CF8), // Indigo
    Color(0xFFA78BFA), // Violet
    Color(0xFFF472B6), // Pink
    Color(0xFF34D399), // Emerald
    Color(0xFF60A5FA), // Blue
    Color(0xFFFBBF24), // Amber
  ];

  Widget _buildCalendar(Map<DateTime, List<CalendarEvent>> eventsMap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = Theme.of(context).cardTheme.color;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final subTextColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: isDark
            ? null
            : Border.all(
                color: const Color(0xFFE2E8F0)), // Add border in Light Mode
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.only(bottom: 12),
      child: TableCalendar<CalendarEvent>(
        locale: Localizations.localeOf(context).toString(),
        firstDay: DateTime.utc(2020, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        eventLoader: (day) => eventsMap[_normalizeDate(day)] ?? [],
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        // Styles
        shouldFillViewport: false,
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          titleTextStyle: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
          leftChevronIcon: Icon(Icons.chevron_left, color: subTextColor),
          rightChevronIcon: Icon(Icons.chevron_right, color: subTextColor),
        ),
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          weekendTextStyle:
              const TextStyle(color: Color(0xFFF472B6)), // Pink for weekend
          defaultTextStyle: TextStyle(color: textColor),
          markersMaxCount: 4,
          markerSize: 6.0,
        ),
        calendarBuilders: CalendarBuilders(
          selectedBuilder: (context, day, focusedDay) {
            return Container(
              margin: const EdgeInsets.all(6.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFFA855F7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withOpacity(0.5),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Text(
                '${day.day}',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            );
          },
          todayBuilder: (context, day, focusedDay) {
            return Container(
              margin: const EdgeInsets.all(6.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF6366F1), width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${day.day}',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            );
          },
          markerBuilder: (context, day, events) {
            if (events.isEmpty) return null;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: events
                  .take(3)
                  .map((e) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 1.5),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: _eventColors[
                              e.hashCode.abs() % _eventColors.length],
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: _eventColors[
                                      e.hashCode.abs() % _eventColors.length]
                                  .withOpacity(0.6),
                              blurRadius: 4,
                              spreadRadius: 1,
                            )
                          ],
                        ),
                      ))
                  .toList(),
            );
          },
        ),
      ),
    );
  }

  Map<DateTime, List<CalendarEvent>> _groupEventsByDay(
      List<CalendarEvent> events) {
    final map = <DateTime, List<CalendarEvent>>{};
    for (final event in events) {
      final date = _normalizeDate(event.startDateTime);
      if (map[date] == null) map[date] = [];
      map[date]!.add(event);
    }
    return map;
  }

  Widget _buildEventList(List<CalendarEvent> events) {
    if (events.isEmpty) {
      return Center(
          child: Text(AppLocalizations.of(context)!.noEventsLabel,
              style: const TextStyle(color: Colors.black54, fontSize: 16)));
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      itemCount: events.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final event = events[index];
        final color = _eventColors[event.hashCode.abs() % _eventColors.length];

        final startTime =
            '${event.startDateTime.hour.toString().padLeft(2, '0')}:${event.startDateTime.minute.toString().padLeft(2, '0')}';
        final endTime =
            '${event.endDateTime.hour.toString().padLeft(2, '0')}:${event.endDateTime.minute.toString().padLeft(2, '0')}';

        final isDark = Theme.of(context).brightness == Brightness.dark;
        final cardColor = Theme.of(context).cardTheme.color;
        final textColor = Theme.of(context).colorScheme.onSurface;
        final subTextColor =
            isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

        return InkWell(
          onTap: () => _showEditEventDialog(context, event),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              border: isDark
                  ? null
                  : Border.all(
                      color:
                          const Color(0xFFE2E8F0)), // Add border in Light Mode
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Time Pillar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      startTime,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: textColor),
                    ),
                    Text(
                      endTime,
                      style: TextStyle(fontSize: 12, color: subTextColor),
                    ),
                  ],
                ),
                const SizedBox(width: 16),

                // Color Bar
                Container(
                  width: 4,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.5),
                        blurRadius: 6,
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      if (event.description != null &&
                          event.description!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          event.description!,
                          style: TextStyle(
                              fontSize: 13,
                              color: isDark
                                  ? const Color(0xFFCBD5E1)
                                  : const Color(0xFF64748B)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),

                // Action
                IconButton(
                  icon: const Icon(Icons.delete_outline,
                      color: Color(0xFF94A3B8)),
                  onPressed: () => _confirmDelete(context, event),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime.utc(date.year, date.month, date.day);
  }

  void _showAddEventDialog(BuildContext context) {
    if (_selectedDay == null) return;

    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    TimeOfDay startTime = const TimeOfDay(hour: 9, minute: 0);
    TimeOfDay endTime = const TimeOfDay(hour: 10, minute: 0);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.addEventTitle),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.titleLabel),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                          labelText:
                              AppLocalizations.of(context)!.descriptionLabel),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: startTime,
                              );
                              if (time != null) {
                                setState(() => startTime = time);
                              }
                            },
                            child: Text(
                                '${AppLocalizations.of(context)!.startTimeLabel}: ${startTime.format(context)}'),
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: endTime,
                              );
                              if (time != null) {
                                setState(() => endTime = time);
                              }
                            },
                            child: Text(
                                '${AppLocalizations.of(context)!.endTimeLabel}: ${endTime.format(context)}'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppLocalizations.of(context)!.cancelButton),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty) {
                      final startDateTime = DateTime(
                        _selectedDay!.year,
                        _selectedDay!.month,
                        _selectedDay!.day,
                        startTime.hour,
                        startTime.minute,
                      );
                      final endDateTime = DateTime(
                        _selectedDay!.year,
                        _selectedDay!.month,
                        _selectedDay!.day,
                        endTime.hour,
                        endTime.minute,
                      );

                      // Basic validation
                      if (endDateTime.isBefore(startDateTime)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(AppLocalizations.of(context)!
                                  .endTimeBeforeStartTime)),
                        );
                        return;
                      }

                      ref
                          .read(
                              eventsControllerProvider(widget.groupId).notifier)
                          .addEvent(
                            title: titleController.text,
                            description: descriptionController.text,
                            start: startDateTime,
                            end: endDateTime,
                          );
                      Navigator.pop(context);
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.addButton),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditEventDialog(BuildContext context, CalendarEvent event) {
    final titleController = TextEditingController(text: event.title);
    final descriptionController =
        TextEditingController(text: event.description);
    TimeOfDay startTime = TimeOfDay.fromDateTime(event.startDateTime);
    TimeOfDay endTime = TimeOfDay.fromDateTime(event.endDateTime);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.editEventTitle),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.titleLabel),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                          labelText:
                              AppLocalizations.of(context)!.descriptionLabel),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: startTime,
                              );
                              if (time != null) {
                                setState(() => startTime = time);
                              }
                            },
                            child: Text(
                                '${AppLocalizations.of(context)!.startTimeLabel}: ${startTime.format(context)}'),
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: endTime,
                              );
                              if (time != null) {
                                setState(() => endTime = time);
                              }
                            },
                            child: Text(
                                '${AppLocalizations.of(context)!.endTimeLabel}: ${endTime.format(context)}'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppLocalizations.of(context)!.cancelButton),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty) {
                      final startDateTime = DateTime(
                        event.startDateTime.year,
                        event.startDateTime.month,
                        event.startDateTime.day,
                        startTime.hour,
                        startTime.minute,
                      );
                      final endDateTime = DateTime(
                        event.endDateTime.year,
                        event.endDateTime.month,
                        event.endDateTime.day,
                        endTime.hour,
                        endTime.minute,
                      );

                      final updatedEvent = event.copyWith(
                        title: titleController.text,
                        description: descriptionController.text,
                        startDateTime: startDateTime,
                        endDateTime: endDateTime,
                      );

                      ref
                          .read(
                              eventsControllerProvider(widget.groupId).notifier)
                          .updateEvent(updatedEvent);
                      Navigator.pop(context);
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.saveButton),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, CalendarEvent event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteEventConfirm),
        content: Text(AppLocalizations.of(context)!.deleteEventMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancelButton),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(eventsControllerProvider(widget.groupId).notifier)
                  .deleteEvent(event);
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.deleteButton,
                style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAddMemberDialog(BuildContext context) {
    AuthUser? selectedUser;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Member'),
        content: Consumer(
          builder: (context, ref, child) {
            // Watch available users
            final usersAsync = ref.watch(availableUsersProvider);
            // Watch current members to filter them out
            final membersAsync =
                ref.watch(groupMembersProvider(widget.groupId));

            return usersAsync.when(
              data: (users) {
                // Get list of current member IDs
                final currentMemberIds =
                    membersAsync.value?.map((u) => u.id).toSet() ?? {};

                // Filter out existing members
                final availableToAdd = users
                    .where((u) => !currentMemberIds.contains(u.id))
                    .toList();

                if (availableToAdd.isEmpty) {
                  return Text(AppLocalizations.of(context)!.noNewUsers);
                }

                return DropdownButtonFormField<AuthUser>(
                  decoration: const InputDecoration(labelText: 'Select User'),
                  items: availableToAdd.map((user) {
                    return DropdownMenuItem(
                      value: user,
                      child: Text('${user.displayName} (${user.email})'),
                    );
                  }).toList(),
                  onChanged: (value) => selectedUser = value,
                );
              },
              loading: () => const SizedBox(
                  height: 50,
                  child: Center(child: CircularProgressIndicator())),
              error: (e, st) =>
                  Text('${AppLocalizations.of(context)!.error}$e'),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (selectedUser != null) {
                try {
                  await ref
                      .read(groupsControllerProvider.notifier)
                      .addMember(widget.groupId, selectedUser!.email);
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text(AppLocalizations.of(context)!.memberAdded)));
                  }
                } catch (e) {
                  if (context.mounted) {
                    // Don't close dialog on error, let user try again
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text('${AppLocalizations.of(context)!.error}$e')));
                  }
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showGroupMembersDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Group Members'),
        content: SizedBox(
          width: double.maxFinite,
          child: Consumer(
            builder: (context, ref, child) {
              final membersAsync =
                  ref.watch(groupMembersProvider(widget.groupId));
              return membersAsync.when(
                data: (members) {
                  if (members.isEmpty)
                    return Text(AppLocalizations.of(context)!.noMembersFound);
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: members.length,
                    itemBuilder: (context, index) {
                      final member = members[index];
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(member.displayName[0].toUpperCase()),
                        ),
                        title: Text(member.displayName),
                        subtitle: Text(member.email),
                      );
                    },
                  );
                },
                loading: () => const SizedBox(
                    height: 100,
                    child: Center(child: CircularProgressIndicator())),
                error: (e, st) =>
                    Text('${AppLocalizations.of(context)!.error}$e'),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.closeButton),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteGroup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Group?'),
        content: const Text(
            'Are you sure you want to delete this group? This action cannot be undone and will remove all members and events.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () async {
              try {
                await ref
                    .read(groupsControllerProvider.notifier)
                    .deleteGroup(widget.groupId);
                if (context.mounted) {
                  Navigator.pop(context); // Close Dialog
                  Navigator.pop(context); // Go back to Group List
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
