import 'package:flutter/material.dart';
import '../models/parsed_response.dart';
import '../utils/theme.dart';

class StructuredResponse extends StatelessWidget {
  final String text;
  final HavenTheme theme;

  const StructuredResponse({
    super.key,
    required this.text,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final parsed = ParsedResponse.parse(text);

    if (!parsed.hasStructure) {
      return Text(
        text,
        style: TextStyle(
          color: theme.messageText,
          fontSize: 14,
          height: 1.55,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < parsed.blocks.length; i++) ...[
          _blockWidget(parsed.blocks[i]),
          if (i < parsed.blocks.length - 1) const SizedBox(height: 10),
        ],
      ],
    );
  }

  Widget _blockWidget(ResponseBlock block) {
    switch (block.kind) {
      case BlockKind.urgent:
        return _urgent(block as UrgentBlock);
      case BlockKind.protocol:
        return _protocol(block as ProtocolBlock);
      case BlockKind.critical:
        return _critical(block as CriticalBlock);
      case BlockKind.plain:
        return _plain(block as PlainBlock);
    }
  }

  Widget _urgent(UrgentBlock block) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      decoration: BoxDecoration(
        color: theme.urgent.withValues(alpha: 0.12),
        border: Border(
          left: BorderSide(color: theme.urgent, width: 3),
        ),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(3),
          bottomRight: Radius.circular(3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '▲ ACİL',
            style: TextStyle(
              color: theme.urgent,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            block.text,
            style: TextStyle(
              color: theme.messageText,
              fontSize: 14,
              height: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _protocol(ProtocolBlock block) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '» PROTOKOL',
          style: TextStyle(
            color: theme.protocol,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        for (int i = 0; i < block.steps.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 3, left: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${(i + 1).toString().padLeft(2, '0')}.',
                  style: TextStyle(
                    color: theme.protocol,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    height: 1.5,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    block.steps[i],
                    style: TextStyle(
                      color: theme.messageText,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _critical(CriticalBlock block) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '◆ KRİTİK',
          style: TextStyle(
            color: theme.critical,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        for (final warning in block.warnings)
          Padding(
            padding: const EdgeInsets.only(bottom: 3, left: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '—',
                  style: TextStyle(
                    color: theme.critical,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    height: 1.5,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    warning,
                    style: TextStyle(
                      color: theme.messageText,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _plain(PlainBlock block) {
    return Text(
      block.text,
      style: TextStyle(
        color: theme.messageText,
        fontSize: 14,
        height: 1.55,
      ),
    );
  }
}
