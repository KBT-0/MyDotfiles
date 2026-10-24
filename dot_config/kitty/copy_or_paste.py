# Windows Terminal gibi sag tik: secim varsa kopyala (ve secimi kaldir), yoksa yapistir
from kittens.tui.handler import result_handler


def main(args):
    pass


@result_handler(no_ui=True)
def handle_result(args, answer, target_window_id, boss):
    from kitty.clipboard import get_clipboard_string

    w = boss.window_id_map.get(target_window_id)
    if w is None:
        return
    if w.text_for_selection():
        w.copy_to_clipboard()
        w.clear_selection()
    else:
        text = get_clipboard_string()
        if text:
            w.paste_with_actions(text)
