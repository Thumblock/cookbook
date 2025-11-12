import os
import requests
import streamlit as st

API_BASE = os.getenv("COOKBOOK_API_BASE", "http://127.0.0.1:8000")

st.set_page_config(page_title="Cookbook", page_icon="🍳")
st.title("🍳 Cookbook – Demo UI")

user_id = st.text_input("User ID (UUID)")
max_missing = st.slider("Max missing ingredients", 0, 5, 0) # 0-5 missing, with 0 being default.

col1, col2 = st.columns(2)

with col1:
    st.subheader("Cookable (all)")
    if st.button("Fetch cookable"):
        if not user_id:
            st.warning("Paste a user_id first.")
        else:
            r = requests.get(f"{API_BASE}/users/{user_id}/cookable",
                             params={"max_missing": max_missing}, timeout=10)
            st.write(r.json())

with col2:
    st.subheader("Cookable by tag")
    tag = st.text_input("Tag (e.g., breakfast)")
    if st.button("Fetch by tag"):
        if not user_id or not tag:
            st.warning("Provide user_id + tag.")
        else:
            r = requests.get(f"{API_BASE}/users/{user_id}/cookable-by-tag",
                             params={"tag": tag, "max_missing": max_missing}, timeout=10)
            st.write(r.json())

st.caption("Tip: export COOKBOOK_API_BASE to target a remote API.")