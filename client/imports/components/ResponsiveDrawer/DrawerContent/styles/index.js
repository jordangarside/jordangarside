import styled from "styled-components";
import { Link } from "react-router-dom";
import _Button from "material-ui/Button";
import { colors, fonts, sizes } from "/client/imports/theme";

export const DrawerContentContainer = styled.div`
  background-color: ${colors.background.default};
  display: flex;
  flex-direction: column;
  min-height: 100%;
  width: ${sizes.drawer};
  padding: 10px 0 0;
  box-sizing: border-box;
  width: 256px;
`;
export const LinksContainer = styled.div`
  padding: 15px 0;
`;
export const LinkContainer = styled(Link)`
  && {
    align-items: flex-end;
    color: ${colors.primary};
    justify-content: flex-start;
    text-transform: none;
    width: 100%;
  }
`;
export const Button = styled(_Button)`
  && {
    display: block;
    padding: 13px 35px;
    &:hover {
      background-color: rgba(0, 0, 0, 0.03);
    }
    img {
      margin-right: 10px;
    }
  }
`;
export const LinkIcon = styled.span`
  color: ${colors.primary};
  display: flex;
  align-items: center;
  padding-right: 15px;
`;
export const LinkText = styled.span`
  border: none;
  color: black;
  cursor: pointer;
  font-size: 18px;
  font-weight: 300;
  letter-spacing: 0.02rem;
  line-height: 150%;
  position: relative;
  text-align: left;
  text-transform: lowercase;
`;
export const aContainer = styled.a`
  && {
    color: black;
    border: none;
    cursor: pointer;
    font-size: 18px;
    font-weight: 300;
    letter-spacing: 0.02rem;
    line-height: 150%;
    position: relative;
    text-align: left;
    text-transform: lowercase;
  }
`;
export const FooterContainer = styled.div``;
