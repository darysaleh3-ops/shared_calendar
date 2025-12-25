import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../groups/presentation/groups_controller.dart';
import 'events_controller.dart';
import '../domain/event.dart';
import '../../auth/domain/auth_user.dart';
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
          loading: () => const Text('Loading...'),
          error: (_, __) => const Text('Calendar'),
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
                                  : 'No Date Selected',
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
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEventDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Event'),
        backgroundColor: const Color(0xFF8AB4F8),
      ),
    );
  }

  // Google Calendar Colors (Material Design)
  final List<Color> _eventColors = const [
    Color(0xFF8AB4F8), // Cornflower Blue
    Color(0xFF33B679), // Sage
    Color(0xFFD50000), // Tomato
    Color(0xFFE67C73), // Flamingo
    Color(0xFF7986CB), // Lavender
    Color(0xFF0F9D58), // Basil
  ];

  Widget _buildCalendar(Map<DateTime, List<CalendarEvent>> eventsMap) {
    return TableCalendar<CalendarEvent>(
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
      headerStyle: const HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white70),
        rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white70),
      ),
      calendarStyle: const CalendarStyle(
        outsideDaysVisible: true,
        weekendTextStyle: TextStyle(color: Color(0xFFE67C73)), // Flamingo
        defaultTextStyle: TextStyle(color: Colors.white),
        markersMaxCount: 4,
        markerSize: 6.0,
      ),
      calendarBuilders: CalendarBuilders(
        todayBuilder: (context, day, focusedDay) {
          return Container(
            margin: const EdgeInsets.all(1.0),
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 4.0),
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xFF8AB4F8),
                shape: BoxShape.circle,
              ),
              child: Text(
                '${day.day}',
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
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
                      margin: const EdgeInsets.symmetric(horizontal: 1.0),
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        // Use hash of event title to pick a color, stable across rebuilds
                        color: _eventColors[
                            e.hashCode.abs() % _eventColors.length],
                        shape: BoxShape.circle,
                      ),
                    ))
                .toList(),
          );
        },
        defaultBuilder: (context, day, focusedDay) {
          return Center(
              child: Text('${day.day}',
                  style: const TextStyle(color: Colors.white70)));
        },
        outsideBuilder: (context, day, focusedDay) {
          return Center(
              child: Text('${day.day}',
                  style: const TextStyle(color: Colors.white24)));
        },
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
      return const Center(
          child: Text('No events.', style: TextStyle(color: Colors.white54)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        final color = _eventColors[event.hashCode.abs() % _eventColors.length];

        // Mock time range for UI polish (real data would be used normally)
        final startTime =
            '${event.startDateTime.hour.toString().padLeft(2, '0')}:${event.startDateTime.minute.toString().padLeft(2, '0')}';
        final endTime =
            '${event.endDateTime.hour.toString().padLeft(2, '0')}:${event.endDateTime.minute.toString().padLeft(2, '0')}';

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: InkWell(
            onTap: () => _showEditEventDialog(context, event),
            borderRadius: BorderRadius.circular(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Time Column
                SizedBox(
                  width: 60,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      startTime,
                      textAlign: TextAlign.right,
                      style:
                          const TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Event Card
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8.0),
                      border:
                          Border(left: BorderSide(color: color, width: 4.0)),
                    ),
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: color, // Title matches bar color
                          ),
                        ),
                        if (event.description != null &&
                            event.description!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            event.description!,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white60),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '$startTime - $endTime',
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.white38),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon:
                      const Icon(Icons.delete, color: Colors.white38, size: 20),
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
    final titleController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Event'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title')),
            TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Description')),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () {
                ref
                    .read(eventsControllerProvider(widget.groupId).notifier)
                    .addEvent(
                      title: titleController.text,
                      description: descController.text,
                      start: _selectedDay ?? DateTime.now(),
                      end: (_selectedDay ?? DateTime.now())
                          .add(const Duration(hours: 1)),
                    );
                Navigator.pop(context);
              },
              child: const Text('Add')),
        ],
      ),
    );
  }

  void _showEditEventDialog(BuildContext context, CalendarEvent event) {
    final titleController = TextEditingController(text: event.title);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Event'),
        content: TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Title')),
        actions: [
          TextButton(
              onPressed: () {
                ref
                    .read(eventsControllerProvider(widget.groupId).notifier)
                    .updateEvent(event.copyWith(title: titleController.text));
                Navigator.pop(context);
              },
              child: const Text('Save')),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, CalendarEvent event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () {
                ref
                    .read(eventsControllerProvider(widget.groupId).notifier)
                    .deleteEvent(event);
                Navigator.pop(context);
              },
              child: const Text('Delete')),
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

                if (availableToAdd.isEmpty)
                  return const Text('No new users available to add.');

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
              error: (e, st) => Text('Error: $e'),
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
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Member added')));
                  }
                } catch (e) {
                  if (context.mounted) {
                    // Don't close dialog on error, let user try again
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Error: $e')));
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
                  if (members.isEmpty) return const Text('No members found.');
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
                error: (e, st) => Text('Error: $e'),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
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
