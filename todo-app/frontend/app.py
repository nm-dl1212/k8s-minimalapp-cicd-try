import streamlit as st
import requests
import os

API_URL = os.getenv("API_URL", "http://backend:5000")

st.title("🍣Osushi App")

new_todo = st.text_input("新しいをお寿司を追加")
if st.button("追加"):
    if new_todo:
        response = requests.post(f"{API_URL}/todos", json={"text": new_todo})
        if response.status_code == 200:
            st.success("お寿司を追加しました！")
            st.rerun()
        else:
            st.error("エラーが発生しました")

st.subheader("登録済みのお寿司")
todos = requests.get(f"{API_URL}/todos").json()
for todo in todos:
    col1, col2 = st.columns([4, 1])
    col1.write(todo["text"])
    if col2.button("削除", key=todo["id"]):
        requests.delete(f"{API_URL}/todos/{todo['id']}")
        st.rerun()
